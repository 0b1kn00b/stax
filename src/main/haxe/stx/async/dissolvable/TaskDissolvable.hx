package stx.async.dissolvable;

import stx.async.ifs.Dissolvable in IDissolvable;
import stx.rct.TasK;

class TaskDissolvable implements IDissolvable{
  private var dissolved        : Bool;
  private var task            : Task;
  public function new(task:Task){
    this.task     = task;
    this.dissolved = false;
  }
  public function dispose():Void{
    if(!this.dissolved){
      this.dissolved = true;
      this.task.stop();
    }
  }
}