package hx.sch;

import stx.Period;

import hx.ifs.Scheduler in IScheduler;

class EventScheduler implements IScheduler{ 
  public function new(){

  }
  public inline function when(abs:Float,fn:Run):Void{
    var wait = abs - Period.now().toFloat();
    trace(wait);
    haxe.Timer.delay(fn.run,Std.int(wait*1000));
  }
  public inline function wait(rel:Float,fn:Run):Void{
    when(Period.now().add(rel),fn);
  }
  public inline function now(fn:Run):Void{
    wait(0,fn);
  }
  public inline function latch(){

  }
}