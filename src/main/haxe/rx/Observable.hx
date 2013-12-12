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

using stx.Option;
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
  @:from static public function fromIterableChunk<T>(itr:Iterable<Chunk<T>>):Observable<T>{
    return new IterableChunkObservable(itr);
  }
  @:from static public function fromIterable<T>(itr:Iterable<T>):Observable<T>{
    return new IterableObservable(itr);
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
  public function each(fn:Chunk<T>->Void):Disposable{
    return Observables.each(this,fn);
  }
  /*
    @:from static public function fromContinuation<T>(cnt:Continuation<Disposable,Chunk<T>>):Observable<T>{
      var ct : ContinuationType<Disposable,Chunk<T>>  = cnt;
      var ot : ObservableType<T>                      = new ObservableDelegate(ct);
    return new Observable(ot);
  }*/
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
}
class Observables{
  static public function each<A>(source:Observable<A>,fn:Chunk<A>->Void){
    return source.subscribe(fn);
  }
  static public function scan<A>(source:Observable<A>,accumulator:Reduce<A,A>,?seed:A):Observable<A>{
    var hasSeed = option(seed).isDefined();
    return function(observer:Observer<A>):Disposable{
      var hasAccumulation = false, accumulation = null  , hasValue = false;
      return source.subscribe(
        function(chk:Chunk<A>):Void{
          switch(chk){
            case Val(v) : 
              try{
                if(!hasValue){
                  hasValue = true;
                }
                if(hasAccumulation){
                  accumulation    = accumulator(accumulation,v);
                }else{
                  accumulation    = hasSeed ? accumulator(seed,v) : v; 
                  hasAccumulation = true;
                }
              }catch(f:Fail){
                observer.onFail(f); return;
              }catch(e:Dynamic){
                observer.onFail(fail(NativeError(e))); return;
              }
              observer.onData(accumulation);
            case End(e) : 
              observer.onFail(e);
            case Nil    : 
              if (!hasValue && hasSeed) {
                observer.onData(seed);
              }
              observer.onDone();
          }
        }
      );
    }
  }
  static public function aggregate<T,U>(source:Observable<T>,?seed:U){
    /**
    observableProto.startWith = function () {
        var values, scheduler, start = 0;
        if (!!arguments.length && 'now' in Object(arguments[0])) {
            scheduler = arguments[0];
            start = 1;
        } else {
            scheduler = immediateScheduler;
        }
        values = slice.call(arguments, start);
        return enumerableFor([observableFromArray(values, scheduler), this]).concat();
    };

    */
  }
  //static public function startWith<T>(source:Observable<T>,values:Array<T>,?scheduler)
  static public function finalValue<T>(source:Observable<T>){
    return function(observer){
      var value = None;
      return source.subscribe(function(chk:Chunk<T>)
        switch(chk){
          case Val(v) : value = Some(v);
          case End(e) : 
            observer.onFail(e);
          case Nil    : 
            switch (value) {
                case None     : 
                  observer.onFail(fail(NullError()));
                case Some(v)  : 
                  observer.onData(v);
                  observer.onDone();
              }
        }
      );
    }
  }
  /*static public function fromArray<T>(fn:Array<T>,sch:Scheduler){
    
  }*/
  /*static public function startWith(source:Observable){
    var values = [], start = 0;
  }*/
  static public function materialize<T>(source:Observable<T>):Observable<Chunk<T>>{
    return function(observer) {
      return source.subscribe(
        function(x:Chunk<T>){
          switch (x) {
            case Val(v) : 
              observer.onData(Val(v));
            case End(e) :
              observer.onData(End(e));
              observer.onDone();
            case Nil    : 
              observer.onData(Nil);
              observer.onDone();
          }
        }
      );
    }
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
class ReactorChunkObservables{
  static public function observe<T>(rct:Reactor<Chunk<T>>):Observable<T>{
    return new ReactorChunkObservable(rct);
  }
}
class IterableChunkObservables{
  static public function observe<T>(itr:Iterable<Chunk<T>>):Observable<T>{
    return new IterableChunkObservable(itr);
  }
}
class IterableObservables{
  static public function observe<T>(itr:Iterable<T>):Observable<T>{
    return new IterableObservable(itr);
  }
}