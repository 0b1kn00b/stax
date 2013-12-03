package hx.sch;

import Prelude;

import hx.sch.ThreadScheduler.ThreadSchedulerHelper.*;

import hx.utl.RetreatTimer;
import hx.utl.Id;

import haxe.Timer;
import stx.Period;
import Stax.*;

import stx.Fail;
import stx.Log.*;

using stx.Option;
using stx.Iterables;
using stx.Maths;
using stx.Arrays;
using stx.Tuples;

import hx.ifs.Run in IRun;
import hx.ifs.Action in IAction;
import hx.ifs.Scheduler in IScheduler;

#if neko
import Sys.*;
import neko.vm.Thread;
import neko.vm.Lock;
import neko.vm.Mutex;

typedef SchedulerRequest = Tuple2<Float,Int>;
typedef SchedulerEntry   = Tuple3<Float,Run,Int>;

@doc("Simple thread scheduler. Uses a retreat timer for polling.")
class ThreadScheduler implements IScheduler{
  private var retreat : RetreatTimer;
  private var command : ThreadAction;

  public function new(){
    trace(debug('new ThreadScheduler'));
    this.command = new ThreadAction(this);
    this.retreat = new RetreatTimer();
  }
  public inline function when(abs:Float,fn:Run):Void{
    retreat.reset();
    abs = Period.now().toFloat() > abs ? Period.now() : abs;
    command.add(abs,fn);
  }
  public inline function wait(rel:Float,fn:Run):Void{
    when(Period.now().add(rel),fn);
  }
  public inline function now(fn:Run):Void{
    wait(0,fn);
  }
  public function latch():Void{
    while(!command.isEmpty()){
      sleep(retreat.next());
    }
    command.stop();
  }
}
class ThreadAction implements IAction<Id>{
  private var ids         : IdCache;
  private var scheduler   : ThreadScheduler;
  private var thread      : Thread;
  private var entries     : Array<SchedulerEntry>;
  public var mutex        : Mutex;

  public function new(scheduler){
    trace(debug('new ThreadAction'));
    this.mutex        = new Mutex();
    this.entries      = [];
    this.ids          = new IdCache();
    this.scheduler    = scheduler;
    this.thread       = new_thread();
  }
  private function new_thread(){
    var runner        = new ThreadRun(this);
    return Thread.create(runner.run);
  }
  private function ensure(){
    if(thread == null){
      this.thread = new_thread();
    }
  }
  public function ready(){
    return entries.filter(
      function(x){
        return x.fst() <= now();
      }
    );
  }
  public inline function stop(){
    thread.sendMessage(Stop);
    thread = null;
  }
  public function add(time:Float,run:Run){
    ensure();
    var id  = ids.next().native();
    entries.push(tuple3(time,run,id));
    thread.sendMessage(Schedule(time,id));
  }
  public function apply(key:Id):Void{
    ensure();
    entries.search(
      function(x){
        return x.thd() == key.native();
      }
    ).each(
      function(entry){
        entries.remove(entry);
        ids.free(key.native());
        entry.snd().run();
      }
    );
  }
  public function isEmpty(){
    mutex.acquire();
    var o = entries.size() == 0;
    mutex.release();
    return o;
  }
}
class ThreadRun implements IRun{
  private var retreat : RetreatTimer;
  private var command : ThreadAction;
  private var stack   : Array<SchedulerRequest>;

  public function new(command){
    trace(debug('new ThreadRun'));
    this.stack    = [];
    this.command  = command;
    this.retreat  = new RetreatTimer();
  }
  public function run(){
    trace(debug('run'));
    #if debug run_debug#else run_prdct#end();
  }
  private inline function run_debug(){
    try{
      run_prdct();      
    }catch(e:Dynamic){
      trace(error(fail(e)));
    }
  }
  private inline function run_prdct(){
    while(true){
      var msg : Null<ThreadMessage<SchedulerRequest>> = null;
          msg = Thread.readMessage(false);
      if(msg == null){
        trace(debug('no message $stack'));
        var n     = this.retreat.next();
        var next  = n + Timer.stamp();
        var t     = stack[0];
        var time  = t == null ? n : next > t.fst() ? t.fst() - now() : n;
            time  = time < 0 ? 0 : time;
        command.ready().each(
          function(a,b,c){
            trace(debug("apply"));
            this.command.mutex.acquire();
            command.apply(c);
            this.command.mutex.release();
            stack = stack.filter(
              function(l,r){
                return r!= c;
              }.tupled()
            );
          }.tupled()
        );
        sleep(time);
      }else{
        trace(debug('message $stack'));
        switch (msg) {
          case Schedule(a,b)      : 
            retreat.reset();
            var used    = false;
            var nstack  = [];
            if(stack.length == 0){
              stack.push(tuple2(a,b));
            }else{
              for(val in stack){
                if( val.fst() > a && !used){
                  used = true;
                  nstack.push(tuple2(a,b));
                }
                nstack.push(val);
              }
              stack = nstack;
            }
          case Stop : 
            break;
        }
      }
    }
  }
}
enum ThreadMessage<T>{
  Stop;
  Schedule(time:Float,id:Int);
}
#end
class ThreadSchedulerHelper{
  static inline public function now():Float{
    return Period.now();
  }
  static public inline function delta(f:Float){
    return f - now();
  }
}