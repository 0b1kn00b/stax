package rx.disposable;

import stx.Eventual;

import rx.ifs.Disposable in IDisposable;

class EventualDisposable implements IDisposable{
  private var disposed        : Bool;
  private var eventual  : Eventual<Disposable>;

  public function new(eventual){
    this.eventual = eventual;
  }
  public function dispose(){
    if(!disposed){
      disposed = true;
      eventual.foreach(
        function(x){
          x.dispose();
        }
      );
    }
  }
}