package hx.ifs;

import Prelude;

import hx.NetEffect;
import hx.Run;
import hx.sch.Task;

import stx.Arrowlet;

interface Scheduler{
  @doc("Schedule a `Run` in absolute time.")
  public function when(task:Task,abs:Float):Void;
  @doc("Schedule a `Run` relative to now.")
  public function wait(task:Task,rel:Float):Void;
  @doc("Start the scheduler, and prevent exit of program in threaded environments.")
  public function run():Void;
  @doc("Schedule the task to take place at `time` where Left is absolute and Right is relative")
  public function schedule(tsk:Task,?time:Pick<Float>):Void;
  @doc("Schedule the task to take place immediately")
  public function immediate(tsk:Task):Void;
  @doc("produces time, internal clock")
  public function now():Float;
}