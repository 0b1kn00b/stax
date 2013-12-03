package rx.disposable;

import Prelude;
import stx.Fail;

import rx.ifs.Disposable in IDisposable;

class SingleAssignmentDisposable implements IDisposable{
  public var disposed(default,null)           : Bool;

  @:isVar public var disposable(get,set)      : Disposable;
  private function get_disposable(){
    return disposable;
  }
  private function set_disposable(v:Disposable):Disposable{
    if (disposable!=null){
      throw IllegalOperationError('Can only assign SingleAssignmentDisposable once');
    }
    return this.disposable = v;
  }
  public function new(){
    this.disposed = false;
  }
  public function dispose(){
    if(!disposed){
      disposed = true;
      disposable.dispose();
      disposable = null;
    }
  }
}