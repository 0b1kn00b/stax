package stx.fnc;

import stx.Log.*;

import Prelude.Tuple2;
import Prelude.Endo;
import Prelude.Outcome;

import stx.fnc.Box in ABox;

import stx.fnc.ifs.Monad in IMonad;

abstract Monad<T>(IMonad<Dynamic,T>) from IMonad<Dynamic,T> to IMonad<Dynamic,T>{
  public function new(v){
    this = v;
  }
  public function flatMap<U>(fn: T->Monad<U>,?self: Dynamic):Monad<U>{
    return this.flatMap(fn,self);
  }
  public function map<U>(fn: T->U,?self: Dynamic):Monad<U>{
    return this.map(fn,self);
  }
  public function iterator():Iterator<T>{
    return this.iterator();
  }
  public function box<U>():ABox<Monad<U>>{
    return this.box();
  }
  @:from static public function fromArray<T>(arr: Array<T>):Monad<T>{
    trace(debug('array monad'));
    var m : Monad<T> =  new stx.fnc.mnd.Array(arr);
    return m;
  }
  @:from static public function fromOutcome<T>(oc: Outcome<T>):Monad<T>{
    trace(debug('outcome monad'));
    var m : Monad<T> =  new stx.fnc.mnd.Outcome(oc);
    return m;
  }
  @:from static public function fromState<S,R>(fn: S->Tuple2<R,S>):Monad<R>{
    trace(debug('state monad'));
    var m : Monad<R> =  new stx.fnc.mnd.State(fn);
    return m;
  }
}
class Monads{
  static public function flatMap<T,U>(m: Monad<T>,fn: T->Monad<U>,?self: Dynamic):Monad<U>{
    return m.flatMap(fn,self);
  }  
  static public function map<T,U>(m: Monad<T>,fn: T->U,?self: Dynamic):Monad<U>{
    return m.map(fn,self);
  }  
  static public function each<T>(m: Monad<T>,fn: T->Void):Monad<T>{
    return m.map(inline function(x){fn(x);return x;});
  }
}
class BindSyntactics{
  static public function _<T,U,V>(fn: Monad<T>->Monad<Monad<U>>->Dynamic->Monad<Monad<U>>){
    /*return function(s:Monad<T>){
      return tuple2(fn,s);
    }*/
  }
}