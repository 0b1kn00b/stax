package hx.sch;

import hx.sch.ThreadScheduler.ThreadSchedulerHelper.*;

import hx.utl.Id;

import haxe.Timer;
import stx.Time;
import Stax.*;

import stx.Fail;
import stx.Log.*;

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

typedef SchedulerRequest = Tuple2<Float,Int>;
typedef SchedulerEntry   = Tuple3<Float,Run,Int>;

class ThreadScheduler<T> implements IScheduler{
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
  private var scheduler   : ThreadScheduler<Dynamic>;
  private var thread      : Thread;
  private var entries     : Map<Int,SchedulerEntry>;

  public function new(scheduler){
    trace(debug('new ThreadCommand'));
    this.ids          = new IdCache();
    this.scheduler    = scheduler;
    var runner        = new ThreadRun(this);
    this.thread       = Thread.create(runner.run);
    this.entries      = new Map();
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
    entries.set(id,tuple3(time,run,id));
    thread.sendMessage(Schedule(time,id));
  }
  public function apply(key:Id):Void{
      var entry = entries.get(key.native());
                  entries.remove(key.native());
          ids.free(key.native());
          entry.snd().run();
  }
  public function isEmpty(){
    return entries.size() == 0;
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
      var msg : Null<ThreadMessage<SchedulerRequest>> = Thread.readMessage(false);
      if(msg == null){
        var n     = this.retreat.next();
        var next  = n + Timer.stamp();
        var t     = stack[0];
        var time  = t == null ? n : next > t.fst() ? t.fst() - now() : n;
            time  = time < 0 ? 0 : time;
        command.ready().foreach(
          function(a,b,c){
            command.apply(c);
            stack = stack.filter(
              function(l,r){
                return r!= c;
              }.tupled()
            );
          }.tupled()
        );
        sleep(time);
      }else{
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
class RetreatTimer{
  private var min     : Float;
  private var max     : Float;
  private var mul     : Float;
  private var current : Float;

  public function new(min=0.00001,max=1,mul=1.8){
    this.current  = min;
    this.min      = min;
    this.max      = max;
    this.mul      = mul;
  }
  public function reset(){
    this.current  = min;
  }
  public function step():Void{
    this.current  = (this.current*mul).clamp(min,max);
  }
  public function next():Float{
    step();
    return this.current;
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