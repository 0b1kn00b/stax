package stx.fnc;

import stx.fnc.ifs.Foldable in IFoldable;

abstract Foldable<T>(IFoldable<T>) from IFoldable<T> to IFoldable<T>{
  public function new(v){
    this = v;
  }
  public function fold(mon:Monoid<A>,?self:Dynamic):A{
    return this.fold(mon,self);
  }
  public function foldMap(fn: A->B, mon:Monoid<B>,?self:Dynamic):B;{
    return this.foldMap(fn,mon,self);
  }
  public function foldLeft<B>(init:A, f:A->B->A,?self:Dynamic):A; {
    return this.foldLeft(init,f,self);
  }
  public function foldRight<B>(init:B, f:A->B->B,?self:Dynamic):B{
    return this.foldRight(init,f,self);
  }
  public function foldLeft1(f:A->A->A, ?self:Dynamic):A{
    return this.foldLeft1(f,self);
  }
  public function foldRight1(f:A->A->A, ?self:Dynamic):A{
    return this.foldRight1(f,self);
  }
}