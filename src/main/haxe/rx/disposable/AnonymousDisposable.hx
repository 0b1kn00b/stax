package rx.disposable;

import Stax.*;
import Prelude;
import rx.ifs.*;

import rx.ifs.Disposable in IDisposable;

class AnonymousDisposable implements IDisposable{
  public var disposed(default,null):Bool;

  public function new(_dispose){
    this._dispose = _dispose;
  }
  private dynamic function _dispose(){
    except()(ArgumentError('dispose',NullError()));
  }
  public function dispose(){
    if(!disposed){
      disposed = true;
      _dispose();
    }
  }
}