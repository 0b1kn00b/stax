package hx.sch;

import Prelude;


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
    trace(debug('timer start'));
    function _run(){
      run();
      if(!stopped){
        trace(debug('continue'));
        scheduler.wait(_run,interval);
      }
    }
    scheduler.wait(_run,interval);
  }
  public function stop(){
    stopped = true;
  }
  static public function wait(fn:Niladic,interval:Float){
    var t = new Timer(interval);
        t.run = function(){
          fn();
          t.stop();
        }
        t.start();
  }
}