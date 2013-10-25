package stx.rx.disposable;

import stx.ds.Set;
import stx.ds.Map;

class CompositeDisposable implements Disposable extends Set<Disposable>{
  private var disposed        : Bool;
  public function new(?map){
    super(map ? map = Map.create());
    this.disposed = false;
  }
  public function dispose(){
    if(!disposed){
      disposed = true;
      this.foreach(
        function(x){
          x.dispose();
        }
      );
    }
  }
}