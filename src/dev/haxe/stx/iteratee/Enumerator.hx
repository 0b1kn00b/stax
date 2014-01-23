package stx.iteratee;

import stx.iteratee.ifs.Enumerator in IEnumerator;

abstract Enumerator<E,A,B>(IEnumerator<E,A,B>) from IEnumerator<E,A,B> to IEnumerator<E,A,B>{
  public function new(v){
    this = v;
  }
  public function apply(it:Iteratee<E,A>):Eventual<Iteratee<E,B>>{
    return this.apply(it);
  }
  @:from static public function fromEnumeratorMethod<E,A,B>(fn:Iteratee<E,A>->Eventual<Iteratee<E,B>>):Enumerator<E,A,B>{
    return new AnonymousEnumerator(fn);
  }
}