package rx.disposable;

using stx.Iterables;
import hx.ds.Set;

import rx.ifs.Disposable in IDisposable;

class CompositeDisposable implements IDisposable{
  @:allow(rx.disposable)private var set             : Set<Disposable>;
  @:allow(rx.disposable)private var disposed        : Bool;
  public function new(){
    this.set      = new Set();
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
  public function add(d:Disposable):Void{
    set.add(d);
  }
  public function rem(d:Disposable):Void{
    set.rem(d);
  }
  public function iterator():Iterator<Disposable>{
    return set.iterator();
  }
}