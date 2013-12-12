package hx.sch;

import hx.sch.Task;

import stx.Period;

import hx.ifs.Scheduler in IScheduler;

class EventScheduler extends BaseScheduler{ 
  public function new(){

  }
  override public function scheduleProcessImmediate(prc:Run):Void{
    haxe.Timer.delay(prc.run,0); 
  }  
  override public inline function scheduleProcessWhen(prc:Run,abs:Float):Void{
    var wait = abs - now();
    haxe.Timer.delay(prc.run,Std.int(wait*1000));
  }
  override public function scheduleProcessWait(prc:Run,rel:Float):Void{
    scheduleProcessWhen(prc,Period.now().add(rel));
  }
  override public function scheduleServiceImmediate(svc:NetEffect):Void{
    haxe.Timer.delay(svc.invoke,0); 
  }
  override public function scheduleServiceWhen(svc:NetEffect,abs:Float):Void{
     scheduleProcessWhen(svc.invoke,abs);
  }
  override public function scheduleServiceWait(svc:NetEffect,rel:Float):Void{
    scheduleProcessWait(svc.invoke,rel); 
  }
  override public inline function latch(){

  }
}