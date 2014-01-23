package stx;

using stx.Functions;

import stx.async.Eventual;
import stx.async.Continuation;

typedef CallbackType<T> = T -> Void;

abstract Callback<T>(CallbackType<T>) from CallbackType<T> to CallbackType<T>{
  public function new(v){
    this = v;
  }
  public inline function invoke(v:T):Void{
    return this(v);
  }
}