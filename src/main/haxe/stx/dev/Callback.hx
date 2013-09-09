package stx;

using stx.Functions;

import stx.Eventual;
import stx.Continuation;

typedef CallbackType<T> = T -> Void;

abstract Callback<T>(CallbackType<T>) from CallbackType<T> to CallbackType<T>{
  public function new(v){
    this = v;
  }
  @:from public static inline function fromEventual(v:Eventual<T>):Callback<T>{
    var handler = function(v:T){
      
    }
    v.foreach(handler);
    return handler;
  }
  public inline function invoke(v:T):Void{
    return this(v);
  }
}