package hx.ifs;

import Prelude;

import hx.NetEffect;
import hx.Run;
import hx.scheduler.Task;

import stx.async.Arrowlet;

interface Scheduler{
  @doc("produces time, internal clock")
  public function now():Float;

  @doc("Schedule the task to take place at `time` where Left is absolute and Right is relative")
  public function schedule(tsk:Task,?time:Option<Pick<Float>>):Void;

  @doc("Schedule the task to take place immediately")
  public function immediate(tsk:Task):Void;

  @doc("Schedule a `Run` relative to now.")
  public function wait(task:Task,rel:Float):Void;

  @doc("Schedule a `Run` in absolute time.")
  public function when(task:Task,abs:Float):Void;
  
  @doc("Start the scheduler.")
  public function run():Void;

  @doc("Keep the thing running in the current function")
  public function latch():Void;
}