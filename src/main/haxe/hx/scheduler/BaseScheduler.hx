package hx.scheduler;


import hx.ifs.Scheduler;

import Stax.*;
import Prelude;

import hx.scheduler.Task;

import stx.async.Arrowlet;

class BaseScheduler implements hx.ifs.Scheduler{
  public function now():Float{
    return haxe.Timer.stamp();
  }
  public function schedule(tsk:Task,?time:Option<Pick<Float>>):Void{
    time = time == null ? None : time;
    switch (time) {
      case None               : immediate(tsk);
      case Some(Left(rel))    : wait(tsk,rel);
      case Some(Right(abs))   : when(tsk,abs);
    }
  }
  public function when(tsk:Task,abs:Float):Void{
    except()(ArgumentError(here().methodName,NullError()));
  }
  public function wait(tsk:Task,rel:Float):Void{
    except()(ArgumentError(here().methodName,NullError()));
  }
  public function immediate(tsk:Task):Void{
    except()(ArgumentError(here().methodName,NullError()));
  }
  public function run():Void{
    except()(ArgumentError(here().methodName,NullError()));
  }
  public function latch():Void{
    
  }
}