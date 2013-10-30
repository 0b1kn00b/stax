package hx.sch;

import neko.vm.Thread;

import stx.Log.*;
import hx.ifs.Scheduler;

import stx.ioc.Inject.*;

class Timer{
  private var stopped   : Bool;
  private var scheduler : Scheduler;
  private var interval  : Float;

  public function new(interval:Float,?scheduler:Scheduler){
    this.stopped    = true;
    this.interval   = interval;
    this.scheduler  = scheduler == null ? inject(Scheduler) : scheduler;
  }
  dynamic public function run(){}

  public function start(){
    stopped = false;
    trace(debug('timer start: stopped? $stopped'));
    function _run(){
      run();
      if(!stopped){
        trace(debug('starting'));
        scheduler.wait(interval,start);
      }
    }
    scheduler.wait(interval,_run);
  }
  public function stop(){
    stopped = true;
  }
}