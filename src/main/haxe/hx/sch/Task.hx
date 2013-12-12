package hx.sch;

import hx.sch.task.ArrowletTask;
import hx.sch.task.AnonymousRunTask;
import hx.ifs.Task in ITask;

import Prelude;
import stx.Fail;
import stx.Chunk;

import rx.Disposable;
import rx.Observer;
import rx.Observable;

abstract Task(ITask) from ITask to ITask{
  public function new(v){
    this = v;
  }
  @:from static public function fromFunction(fn:Niladic){
    return new AnonymousRunTask(fn);
  }
  @:from static public function fromArrowletType(fn:Unit->(Unit->Void)->Void){
    return new ArrowletTask(fn);
  }
  public function run():Void{
    this.run();
  }
  public function subscribe(obs:Observer<Unit>):Disposable{
    return this.subscribe(obs);
  }
}