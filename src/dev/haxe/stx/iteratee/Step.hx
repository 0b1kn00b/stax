package stx.iteratee;

import stx.async.Contract;
import stx.Chunk;

enum Step<E,A>{
  Cont(k: Chunk<E>->Iteratee<E,A>);
  Over(a:A, remaining:Chunk<E>);
  Fail(f:Fail, input:Chunk<E>);
}
class Steps{
  static public function Over<E,A,B>(a:A,e:Chunk<E>):Iteratee<E,A>{
    return function(folder:Step<E,A>->Contract<B>):Contract<B>{
      return folder(Step.Over(a,e));
    }
  }
  static public function Cont<E,A,B>(k:Chunk<E>->Iteratee<E,A>):Iteratee<E,A>{
    return function(folder:Step<E,A>->Contract<B>){
      return folder(Step.Cont(k));
    }
  }
  static public function Fail<E,A,B>(err:Fail,e:Chunk<E>):Iteratee<E,A>{
    return function(folder:Step<E,A>->Contract<B>){
      return folder(Step.Fail(err,e));
    }
  }
}