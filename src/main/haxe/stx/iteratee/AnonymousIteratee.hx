package stx.iteratee;

import stx.iteratee.ifs.Iteratee in IIteratee;

class AnonymousIteratee<E,A> implements IIteratee<E,A>{
  public function new(iteratee_method){
    this._fold = iteratee_method;
  }
  public function fold<B>(step:Step<E,A>->Contract<B>):Contract<B>{
    return _fold(step);
  }
  private dynamic function _fold<B>(step:Step<E,A>->Contract<B>):Contract<B>{
    return null;
  }
}