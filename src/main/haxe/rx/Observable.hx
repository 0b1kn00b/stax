package rx;

import Stax.*;

using hx.Reactor;

import stx.utl.Selector;

import stx.Fail;
import stx.Contract;
import stx.Eventual;
import stx.Compare;
import stx.Chunk;
import Prelude;
import stx.Continuation;

using stx.Iterables;
using stx.Types;
using stx.Compose;


import rx.ifs.Observable in IObservable;

import rx.observable.*;
import rx.disposable.*;



typedef ObservableType<T> = IObservable<T>;


abstract Observable<T>(ObservableType<T>) from ObservableType<T> to ObservableType<T>{
  @doc("Produces an Observable that does nothing.")
  @:noUsing static public function unit<T>():Observable<T>{
    return function(obs:Observer<T>):Disposable{ 
      return noop; 
    }
  }
  @doc("Produces an Observable that sends a done message.")
  @:noUsing static public function empty<T>():Observable<T>{
    return function(obs:Observer<T>):Disposable{ 
      obs.apply(Nil);
      return noop; 
    }
  }
  public function new(v){
    this = v;
  }
  public function subscribe(obs:Observer<T>):Disposable{
    return this.subscribe(obs);
  }
  @:from static public function fromAnonymousObservable<T>(fn:Observer<T> -> Disposable){
    return new AnonymousObservable(fn);
  }
  @:from static public function fromT<T>(v:T):Observable<T>{
    return function(observer:Observer<T>){
      observer.onData(v);
      observer.onDone();
      return Disposable.unit();
    }
  }
  /*
    @:from static public function fromContinuation<T>(cnt:Continuation<Disposable,Chunk<T>>):Observable<T>{
      var ct : ContinuationType<Disposable,Chunk<T>>  = cnt;
      var ot : ObservableType<T>                      = new ObservableDelegate(ct);
    return new Observable(ot);
  }*/
  @:to public function toContinuation<T>():Continuation<Disposable,Chunk<T>>{
    return new Continuation(this.subscribe);
  }
  /*
  public function map<U>(fn:T->U):Observable<U>{
    return Observables.map(this,fn);
  }
  public function flatMap<U>(fn:T->Observable<U>):Observable<U>{
    return Observables.flatMap(this,fn);
  }
  */
  /*
  public function each(fn:Chunk<T>->Void):Disposable{
    return Observables.each(this,fn);
  }
  */
  public function next(fn:T->Void){
    return Observables.next(this,fn);
  }
  public function fail(fn:Fail->Void){
    return Observables.fail(this,fn);
  }
  public function done(fn:Niladic){
    return Observables.done(this,fn);
  }
}
class Observables{
  /*static public function first<A>(obs0:Observable<A>):Observable<A>{
    return take(obs0,1);    
  }*/
  /*static public function takeWhile<A>(obs0:Observable<A>,running:Selector<A>):Observable<A>{
    return function(observer:Observer<A>){
      return obs0.next(
        function(chk:A):Void{
          var done = !running.apply(chk);
          if(!done){
            observer.onData(chk);
          }else{
            observer.onDone();
          }
        }
      );
    }
  }*/
/*  static public function take<A>(obs:Observable<A>,num:Int):Observable<A>{
    var count = 0;
    return takeWhile(obs, function(x):Bool{
      count++;
      return count <= num;
    });
  }*/
  @noUsing static public function returns<A>(v:A):Observable<A>{
    return function (observer:Observer<A>) {
      observer.onData(v);
      observer.onDone();
      return Disposable.unit();
    };
  }
  static public function buffer<A>(obs:Observable<A>):Observable<A>{
    return new BufferedObservable(obs);
  }
  @:note("This doesn't belong here")
  @:bug("0b1kn00b: obs2 is replaced by observer in lambda, name change fixes: could be aliasing with auto renaming.")
  static public function concat<A>(obs0:Observable<A>,obs1:Observable<A>):Observable<A>{
    var obs2_ : Observable<A> = buffer(obs0);
    var obs3_ : Observable<A> = buffer(obs1);

    return function(x:Observer<A>):Disposable{
      var ev : Eventual<Disposable> = Eventual.unit();
      var d0 = obs2_.subscribe(
        function(chk:Chunk<A>):Void{
          switch (chk) {
            case Nil  :
              var dsp = 
                obs3_.subscribe(
                  function(chk:Chunk<A>):Void{
                    x.apply(chk);
                  }
                );
              if(!ev.isDelivered()){
                ev.deliver(dsp);
              }
            default   : x.apply(chk);
          }
        }
      );
      var d1 = new EventualDisposable(ev);
      var c  = new CompositeDisposable();
          c.add(d0);
          c.add(d1);
      return c;
    }
  }
  /*static public function merge<A>(obs0:Observable<A>,obs1:Observable<A>):Observable<A>{
    return function(ob:Observer<A>){

    }
  }*/
  static public function each<A>(obs:Observable<A>,fn:Chunk<A>->Void):Disposable{
    return obs.subscribe(
      function(chk:Chunk<A>){
        fn(chk);
      }
    );
  }
  static public function next<A>(obs:Observable<A>,fn:A->Void):Disposable{
    return each(obs,Chunks.success.bind(_,fn));
  }
  static public function fail<A>(obs:Observable<A>,fn:Fail->Void):Disposable{
    return each(obs,Chunks.failure.bind(_,fn));
  }
  static public function done<A>(obs:Observable<A>,fn:Niladic):Disposable{
    return each(obs,Chunks.nothing.bind(_,fn));
  }
  static public function map<A,B>(obs:Observable<A>,fn:A->B):Observable<B>{
    return function(cont: Observer<B>){
      return obs.subscribe(
        function(chk:Chunk<A>){
          switch (chk) {
            case Val(v) : cont.apply(Val(fn(v)));
            case End(e) : noop;
            case Nil    : noop;
          }
        }
      );
    }
  }
  static public function flatMap<A,B>(obs:Observable<A>,fn:A->Observable<B>):Observable<B>{
    return new AnonymousObservable(
      function(cont : Observer<B>){
        var ot = null;
            ot = obs.subscribe(
          function(chk:Chunk<A>):Disposable{ 
            return switch(chk){
              case Val(v) : (fn(v).subscribe(cont)); 
              case End(e) : ot == null ? noop : ot;
              case Nil    : ot == null ? noop : ot;
            }
          }
        );
        return ot;
      }
    );
  }
}
@doc("Observe an Eventual value")
class EventualObservables{
  static public function observe<T>(evt:Eventual<T>):Observable<T>{
    return new EventualObservable(evt);
  }
}
@doc("Observe the Outcome of a Contract.")
class ContractObservables{
  static public function observe<T>(evt:Contract<T>):Observable<T>{
    return new ContractObservable(evt);
  } 
}
@doc("Observe values emitted by a Reactor.")
class ReactorObservables{
  static public function observe<T>(rct:Reactor<T>):Observable<T>{
    return new ReactorObservable(rct.map(Val));
  }
}
@doc("Observe values emitted by a Reactor.")
class ChunkReactorObservables{
  static public function observe<T>(rct:Reactor<Chunk<T>>):Observable<T>{
    return new ReactorObservable(rct);
  }
}
class IterableObservables{
  static public function observe<T>(itr:Iterable<T>):Observable<T>{
    return new IterableObservable(itr.map(Val).add(Nil));
  }
}
class ChunkIterableObservables{
  static public function observe<T>(itr:Iterable<Chunk<T>>):Observable<T>{
    return new IterableObservable(itr);
  }
}