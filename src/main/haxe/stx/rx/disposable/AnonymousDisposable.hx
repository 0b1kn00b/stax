package stx.rx.disposable;

import stx.Prelude;
import stx.rx.ifs.*;

import stx.rx.ifs.Disposable in IDisposable;

class AnonymousDisposable implements IDisposable{
  private var disposed        : Bool;
  private var dispose_method  : CodeBlock;

  public function new(dispose_method){
    this.dispose_method = dispose_method;
  }

  public function dispose(){
    if(!disposed){
      disposed = true;
      dispose_method();
    }
  }
}