package stx.fnc;

import stx.ifs.Container;

import stx.fnc.ifs.Box    in IBox;
import stx.fnc.Pure;

class Box<T> implements IBox<Monad<T>>{
  private var into  : Pure<Monad<T>>;
  private var from  : Container<Dynamic>;

  public function new(m:Monad<T>){
    this.into = cast new Pure(m);
    this.from = m;
  }
  public function box(v: Dynamic):Monad<T>{
    return into.pure(v);
  }
  public function unbox():Dynamic{
    return from.data;
  }
}