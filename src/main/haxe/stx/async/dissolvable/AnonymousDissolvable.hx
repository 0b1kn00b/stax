package stx.async.dissolvable;

import Stax.*;
import Prelude;
import stx.reactive.ifs.*;

import stx.async.ifs.Dissolvable in IDissolvable;

class AnonymousDissolvable implements IDissolvable{
  public var dissolved(default,null):Bool;

  public function new(_dissolve){
    this._dissolve = _dissolve;
  }
  private dynamic function _dissolve(){
    except()(ArgumentError('dissolve',NullError()));
  }
  public function dissolve(){
    if(!dissolved){
      dissolved = true;
      _dissolve();
    }
  }
}