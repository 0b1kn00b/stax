package stx.ioc;

import stx.type.*;
import Prelude;
using stx.Tuples;

import stx.ifs.Reply;

enum BinderType<T> {
  Constructor(type : Class<T>, ?func : Thunk<Array<Dynamic>>);
  Instance(instance : T);
  Provider(provider : Reply<T>);
  Factory(fn:Void->T);
}

abstract Binder<T>(BinderType<T>) from BinderType<T> to BinderType<T>{
  public function new(v){
    this = v;
  }
  @:from static public inline function fromFactory<T>(fn:Void->T):Binder<T>{
    return Factory(fn);
  }
  @:from static public inline function fromConstructor<T>(tp:Tuple2<Class<T>,Void->Array<Dynamic>>):Binder<T>{
    return Constructor(tp.fst(),tp.snd());
  }
  @:from static public inline function fromProvider<T>(rpl:Reply<T>):Binder<T>{
    return Provider(rpl);
  }
  @:from static public inline function fromInstance<T>(o:T):Binder<T>{
    return Instance(o);
  }
}