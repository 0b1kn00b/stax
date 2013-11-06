package stx.iteratee;

import stx.iteratee.ifs.Enumerator in IEnumerator;
import stx.iteratee.Iteratee;

class AnonymousEnumerator<E,A,B> implements IEnumerator<E,A,B>{
  public function new(enumerator:Iteratee<E,A>->Eventual<Iteratee<E,B>>){
    this._apply = enumerator;
  }
  public function apply(it:Iteratee<E,A>):Eventual<Iteratee<E,B>>{
    return _apply(it);
  }
  dynamic private function _apply(it:Iteratee<E,A>):Eventual<Iteratee<E,B>>{
    return null;
  }
}