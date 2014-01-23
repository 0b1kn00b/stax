package hx.scheduler;

using Std;

import hx.scheduler.Task;

import stx.Period;

import hx.ifs.Scheduler in IScheduler;

class EventScheduler extends BaseScheduler{ 
  public function new(){

  }
  override public inline function when(tsk:Task,abs:Float):Void{
    var rel = abs - now();
    haxe.Timer.delay(tsk.run,(rel * 1000).int());
  }
  override public function wait(tsk:Task,rel:Float):Void{
    haxe.Timer.delay(tsk.run, (rel * 1000).int());
  }
  override public function immediate(tsk:Task):Void{
    haxe.Timer.delay(tsk.run,0); 
  }
  override public inline function run(){

  }
}