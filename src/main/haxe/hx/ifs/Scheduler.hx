package hx.ifs;

import Prelude;

import hx.Run;

interface Scheduler{
  @doc("Schedule a `Run` in absolute time.")
  public function when(abs:Float,fn:Run):Void;
  @doc("Schedule a `Run` relative to now.")
  public function wait(rel:Float,fn:Run):Void;
  @doc("Prevent exit of program in single-threaded environments.")
  public function latch():Void;
}