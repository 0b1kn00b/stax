package hx.scheduler;

import hx.ifs.Scheduler;

class ImmediateScheduler extends BaseScheduler implements Scheduler{
  public function new(){}
  override public function when(tsk:Task,abs:Float):Void{
    tsk.run();
  }
  override public function wait(tsk:Task,rel:Float):Void{
    tsk.run();
  }
  override public function immediate(tsk:Task):Void{
    tsk.run();
  }
  override public function run():Void{
    
  }
}