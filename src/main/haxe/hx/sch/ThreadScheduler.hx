package hx.sch;

import hx.sch.ThreadScheduler.ThreadSchedulerHelper.*;

import hx.utl.RetreatTimer;
import hx.utl.Id;

import haxe.Timer;
import stx.Time;
import Stax.*;

import stx.Fail;
import stx.Log.*;

using stx.Option;
using stx.Iterables;
using stx.Maths;
using stx.Arrays;
using stx.Tuples;

import hx.ifs.Run in IRun;
import hx.ifs.Command in ICommand;
import hx.ifs.Scheduler in IScheduler;

#if neko
import Sys.*;
import neko.vm.Thread;
import neko.vm.Lock;
import neko.vm.Mutex;

typedef SchedulerRequest = Tuple2<Float,Int>;
typedef SchedulerEntry   = Tuple3<Float,Run,Int>;

@doc("
  Simple thread scheduler. Uses a retreat timer for polling.
")
class ThreadScheduler implements IScheduler{
  private var retreat : RetreatTimer;
  private var command : ThreadCommand;

  public function new(){
    trace(debug('new ThreadScheduler'));
    this.command = new ThreadCommand(this);
    this.retreat = new RetreatTimer();
  }
  public inline function when(abs:Float,fn:Run):Void{
    retreat.reset();
    abs = Time.now().toFloat() > abs ? Time.now() : abs;//in case abs is earlier than now
    command.add(abs,fn);
  }
  public inline function wait(rel:Float,fn:Run):Void{
    when(Time.now().add(rel),fn);
  }
  public inline function now(fn:Run):Void{
    wait(0,fn);
  }
  public function latch():Void{
    while(!command.isEmpty()){
      sleep(retreat.next());
    }
  }
}
class ThreadCommand implements ICommand<Id>{
  private var ids         : IdCache;
  private var scheduler   : ThreadScheduler;
  private var thread      : Thread;
  private var entries     : Array<SchedulerEntry>;
  public var mutex        : Mutex;

  public function new(scheduler){
    trace(debug('new ThreadCommand'));
    this.mutex        = new Mutex();
    this.entries      = [];
    this.ids          = new IdCache();
    this.scheduler    = scheduler;
    var runner        = new ThreadRun(this);
    this.thread       = Thread.create(runner.run);
  }
  public function ready(){
    return entries.filter(
      function(x){
        return x.fst() <= now();
      }
    );
  }
  public function add(time:Float,run:Run){
    var id  = ids.next().native();
    entries.push(tuple3(time,run,id));
    thread.sendMessage(Schedule(time,id));
  }
  public function apply(key:Id):Void{
    entries.search(
      function(x){
        return x.thd() == key.native();
      }
    ).foreach(
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
  private var command : ThreadCommand;
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
        command.ready().foreach(
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
          case Stop : break;
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
    return Time.now();
  }
  static public inline function delta(f:Float){
    return f - now();
  }
}