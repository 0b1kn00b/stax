package stx.fnc;

import stx.fnc.ifs.Monoid in IMonoid;

abstract Monoid<T>(IMonoid<T>) from IMonoid<T> to IMonoid<T>{
  public function new(v){
    this = v;
  }
  public function append(a1: T, a2: T): T {
    return this.append(a1,a2);
  }
  public function zero(): T{
    
  }
}