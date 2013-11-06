package stx.fnc.ifs;

import stx.Monoid;

interface Foldable{
  public function foldMap<A,B>(self:Dynamic, f:A->B, mon:Monoid<B>):B;
}