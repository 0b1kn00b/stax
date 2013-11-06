package stx.iteratee.ifs;

import stx.Contract;

interface Iteratee<E,A>{
  public function fold<B>(fn:Step<E,A> -> Contract<B>):Contract<B>;
}