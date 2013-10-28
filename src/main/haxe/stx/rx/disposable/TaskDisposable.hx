package stx.rx.disposable;

import stx.ifs.Disposable in IDisposable;
import stx.rct.TasK;

class TaskDisposable implements IDisposable{
  private var disposed        : Bool;
  private var __underlying__  : Task;
  public function new(task:Task){
    this.task     = task;
    this.disposed = false;
  }
  public function dispose():Void{
    if(!this.disposed){
      this.disposed = true;
      this.task.stop();
    }
  }
}