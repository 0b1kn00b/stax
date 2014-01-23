package hx.scheduler;

import hx.scheduler.task.ArrowletTask;
import hx.scheduler.task.RunTaskAnonymous;
import hx.ifs.Task in ITask;

import Prelude;
import stx.Fail;
import stx.Chunk;

import stx.async.Dissolvable;

import stx.reactive.Observer;
import stx.reactive.Observable;

abstract Task(ITask) from ITask to ITask{
  public function new(v){
    this = v;
  }
  @:from static public function fromFunction(fn:Niladic){
    return new RunTaskAnonymous(fn);
  }
  @:from static public function fromArrowletType(fn:Unit->(Unit->Void)->Void){
    return new ArrowletTask(fn);
  }
  public function run():Void{
    this.run();
  }
  public function subscribe(obs:Observer<Unit>):Dissolvable{
    return this.subscribe(obs);
  }
}