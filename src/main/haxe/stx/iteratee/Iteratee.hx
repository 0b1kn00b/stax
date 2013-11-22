package stx.iteratee;

import Prelude;
import Stax.*;

import stx.Fail;
import stx.iteratee.AnonymousIteratee;

import stx.iteratee.ifs.Iteratee in IIteratee;

using stx.Contract;

abstract Iteratee<E,A>(IIteratee<E,A>) from IIteratee<E,A> to IIteratee<E,A>{
  public function new(v){
    this = v;
  }
  public function fold<B>(fn:Step<E,A> -> Contract<B>):Contract<B>{
    return this.fold(fn);
  }
  public function reply():Contract<A>{
    return Iteratees.reply(this);
  }
  @:from static public function fromIterateeMethod<E,A,B>(fn:(Step<E,A> -> Contract<B>)->Contract<B>):Iteratee<E,A>{
    return new AnonymousIteratee(fn);
  }
}
class Iteratees{
  static public function reply<E,A,B>(iteratee:Iteratee<E,A>):Contract<A>{
    return iteratee.fold(
      function(step:Step<E,A>){
        return 
          switch (step) {
            case Step.Over(a,_)               : Contracts.intact(a);
            case Step.Cont(k)                 :
              k(End()).fold(
                function(step1){
                  return switch (step1) {
                    case Step.Over(a,_)       : Contracts.intact(a);
                    case Step.Cont(_)         : Contracts.breach(fail(IllegalOperationError('Divergent Iteratee after Input.End')));
                    case Step.Fail(err,_)     : Contracts.breach(err);
                  }
                }
              );
            case Step.Fail(err,_)             : Contracts.breach(err);
          }
      }
    );
  }
  static public function folds<E,A,B>(it:Iteratee<E,A>,folder:(Step<E,A>->Contract<B>)):Contract<B>{
    return it.fold(folder);
  }
  static public function flatten<E,A>(i:Contract<Iteratee<E, A>>): Iteratee<E, A> {
    return function(folder){
      return i.flatMap(folds.bind(_,folder));
    }
  }
  public function pureFold<E,A,B>(itr:Iteratee<E,A>,folder:Step<E,A> -> B): Contract<B>{
    return itr.fold(function(s) return folder(s).intact());
  }
  public function pureFlatFold<E,A,B,C>(itr:Iteratee<E,A>,folder:Step<E,A>->Iteratee<B,C>):Iteratee<B,C> {
    return flatten(pureFold(itr,folder));
  }
  public function fold1<E,A,B>(
      itr     : Iteratee<E,A>,
      done    : A           -> Chunk<E>         -> Contract<B>
    , cont    : (Chunk<E>   -> Iteratee<E, A>)  -> Contract<B>
    , error   : Fail        -> Chunk<E>         -> Contract<B>
    ) : Contract<B>{
    return itr.fold(
        function(step:Step<E,A>):Contract<B>{
          return switch (step) {
            case Step.Over(a,e)       : done(a,e);
            case Step.Cont(k)         : cont(k);
            case Step.Fail(msg,e)     : error(msg,e); 
          }
        }
      );
  }
  public function flatFold<E,A,B,C>(
      itr   : Iteratee<E,A>,
      done  : A -> Chunk<E>               -> Contract<Iteratee<B,C>>
    , cont  : (Chunk<E> -> Iteratee<E,A>) -> Contract<Iteratee<B,C>>
    , error : Fail -> Chunk<E>            -> Contract<Iteratee<B,C>>
  ):Iteratee<B,C>{
    return flatten(fold1(itr,done,cont,error));
  }
}