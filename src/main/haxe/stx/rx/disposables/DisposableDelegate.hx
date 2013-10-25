package stx.rx.disposable;

import stx.Prelude;

class DisposableDelegate implements Disposable{
  private var disposed        : Bool;
  private var __underlying__  : CodeBlock;

  public function new(__underlying__){
    this.__underlying__ = __underlying__;
  }

  public function dispose(){
    if(!disposed){
      disposed = true;
      __underlying__();
    }
  }
}