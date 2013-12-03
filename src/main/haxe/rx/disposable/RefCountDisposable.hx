package rx.disposable;

import stx.Compare.*;
import Stax.*;
import Prelude;

import rx.ifs.Disposable in IDisposable;

using stx.Iterables;

class RefCountDisposable implements IDisposable{

  public var disposed(default,null) : Bool;
  private var disposable : IDisposable;

  @:allow(rx.disposable)private var count : Int;
  public function new(disposable:IDisposable){
    assert(disposable);
    this.disposable = disposable;
    count = 0;
  }
  public function dispose(){
    if(!disposed && count == 0 && this.disposable == null){
      this.disposable.dispose();
      this.disposable = null;
    }
  }
  @:allow(rx.disposable)private function release(){
    this.count--;
  }
  public function lock():Disposable{
    return new InnerDisposable(this);
  }
}
private class InnerDisposable implements IDisposable{
  public var disposed(default,null):Bool;
  private var parent : RefCountDisposable;
  public function new(parent){
    this.parent = parent;
  }
  public function dispose(){
    if(!disposed){
      parent.release();
      this.disposed = true;
    }
  }
}