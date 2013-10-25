package stx.rx.disposable;

import stx.Fail;

class SingleAssignmentDisposable implements Disposable{
  private var disposed        : Bool;
  private var __underlying__  : Disposable;

  public function new(){
    this.disposed = false;
  }
  public function set(v:Disposable){
    if (__underlying__!=null){
      throw IllegalOperationFail('Can only assign SingleAssignmentDisposable once');
    }
    this.__underlying__ = v;
  }
  public function dispose(){
    if(!disposed){
      disposed = true;
      __underlying__.dispose();
      __underlying__ = null;
    }
  }
}