package rx.disposable;

import stx.Eventual;

import rx.ifs.Disposable in IDisposable;

class EventualDisposable implements IDisposable{
  private var disposed        : Bool;
  private var __underlying__  : Eventual<Disposable>;

  public function new(__underlying__){
    this.__underlying__ = __underlying__;
  }
  public function dispose(){
    if(!disposed){
      disposed = true;
      __underlying__.foreach(
        function(x){
          x.dispose();
        }
      );
    }
  }
}