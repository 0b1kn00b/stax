package pax;

typedef NativeArray<T>    = std.Array<T>;
typedef ArrayCompose<S,T> = NativeArray<S>->NativeArray<T>;

import stx.Prelude;
import stx.Arrays;

using stx.Compose;

class Array<S,T>{
  static public function create(?impl:ArrayCompose<S,T>){
    return new Array(impl);
  }
  private var impl : ArrayCompose<S,T>;
  public function new(?impl:ArrayCompose<S,T>){
    this.impl = impl == null ? cast pure() : impl;
  }
  public inline function apply(a:NativeArray<S>):NativeArray<T>{
    return impl(a);
  }
  public function map<U>(fn:T->U):Array<U>{
    return create(impl.then(Arrays.map.bind(_,fn)));
  }  
  public function flatMap<U>(fn:T->Array<U>):Array<U>{
    return create(impl.then(SArrays.flatMap.bind(_,fn)));
  }
}