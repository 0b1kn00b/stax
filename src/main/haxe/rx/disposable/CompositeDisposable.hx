package rx.disposable;

using stx.Iterables;

import hx.ds.Set;

import rx.ifs.Disposable in IDisposable;

@doc("Represents a group of disposable resources that are disposed together.")
class CompositeDisposable implements IDisposable{
  private var disposables : Array<Disposable>;

  public function new(?disposables){
    this.disposables = disposables == null ? [] : disposables;  
  }
  @:allow(rx.disposable)private var set             : Set<Disposable>;
  public var disposed(default,null):Bool;
  public function new(){
    this.set      = new Set();
    this.disposed = false;
  }
  public function dispose(){
    if(!disposed){
      disposed = true;
      this.each(
        function(x){
          x.dispose();
        }
      );
    }
  }
  public function add(disposable:Disposable){
    var shouldDispose = disposed;

    if (!disposed){
        disposables.add(disposable);
    }
    if(shouldDispose){
      disposable.dispose;
    }
  }
  public function rem(disposable:Disposable){
    var shouldDispose = disposed;

    if (!disposed){
      shouldDispose = disposables.rem(disposable);
    }
    if(shouldDispose){
      disposable.dispose;
    }
  }
  public function size():Int{
    return disposables.length;
  }
  public function add(d:Disposable):Void{
    set.add(d);
  }
  public function rem(d:Disposable):Void{
    set.rem(d);
  }
  public function clear(){
    disposables.each(Disposables.dispose)
    disposables = [];
  }
  public function contains(v:Disposable):Bool{
    return disposables.indexOf(v) != -1;
  }
  public function iterator():Iterator<Disposable>{
    return disposables.iterator();
  }
}