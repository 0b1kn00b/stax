package stx.fnc.ifs;

import stx.Monoid;

interface Foldable<A>{
  public function fold(mon:Monoid<A>,self:Dynamic):A;
  public function foldMap(f:A->B, mon:Monoid<B>,self:Dynamic):B; 
  public function foldLeft<B>(init:A, f:A->B->A,self:Dynamic):A;  
  public function foldRight<B>(init:B, f:A->B->B,self:Dynamic):B;
  public function foldLeft1(f:A->A->A, self:Dynamic):A;
  public function foldRight1(f:A->A->A, self:Dynamic):A;
}