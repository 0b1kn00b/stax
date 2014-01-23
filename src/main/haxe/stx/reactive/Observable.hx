package stx.reactive;

import stx.Compare.*;
import stx.reactive.Rx.*;
import Stax.*;

import hx.ifs.Scheduler;
import hx.reactive.Dispatcher;

using hx.Reactor;

import stx.utl.Selector;

import stx.ioc.Inject.*;

import Prelude;

import stx.Fail;
import stx.async.dissolvable.*;
import stx.async.Dissolvable;
import stx.async.Contract;
import stx.async.Eventual;
import stx.Compare;
import stx.Chunk;
import stx.async.Continuation;

using stx.CallStacks;
using stx.Option;
using stx.Iterables;
using stx.Types;
using stx.Compose;

import stx.reactive.ifs.Observable in IObservable;

import stx.reactive.observable.*;
import stx.reactive.observer.*;
import stx.reactive.dissolvable.*;

typedef ObservableType<T> = IObservable<T>;

abstract Observable<T>(ObservableType<T>) from ObservableType<T> to ObservableType<T>{
  @doc("Produces an Observable that does nothing.")
  @:noUsing static public function unit<T>():Observable<T>{
    return function(obs:Observer<T>):Dissolvable{ 
      return new NullDissolvable();
    }
  }
  @doc("Produces an Observable that sends a done message.")
  @:noUsing static public function empty<T>():Observable<T>{
    return new AnonymousObservable(function(obs:Observer<T>):Dissolvable{ 
      obs.apply(Nil);
      return new NullDissolvable(); 
    });
  }
  public function new(v){
    this = v;
  }
  public function subscribe(obs:Observer<T>):Dissolvable{
    assert(this,'should be observable',cast is(IObservable));
    return this.subscribe(obs);
  }
  @:from static public function fromIterableChunk<T>(itr:Iterable<Chunk<T>>):Observable<T>{
    return new IterableChunkObservable(itr);
  }
  @:from static public function fromIterable<T>(itr:Iterable<T>):Observable<T>{
    return new IterableObservable(itr);
  }
  @:from static public function fromChunkDispatcher<T>(dsp:Dispatcher<Chunk<T>>){
    return new DispatcherChunkObservable(dsp);
  }
  @:from static public function fromAnonymousObservable<T>(fn:Observer<T> -> Dissolvable){
    return new AnonymousObservable(fn);
  }
  @:from static public function fromT<T>(v:T):Observable<T>{
    return function(observer:Observer<T>){
      observer.onData(v);
      observer.onDone();
      return Dissolvable.unit();
    }
  }
  public function each(fn:Chunk<T>->Void):Dissolvable{
    return Observables.each(this,fn);
  }
  public function map<U>(fn:T->U):Observable<U>{
    return Observables.map(this,fn);
  }
  public function merge<T>(src1:Observable<T>):Observable<T>{
    return Observables.merge(this,src1);
  }
  public function filter<T>(selector:T->Bool):Observable<T>{
    return Observables.filter(this,selector);
  }
  public function scan1<T>(accumulator:Reduce<T,T>,?seed:T):Observable<T>{
    return Observables.scan1(this,accumulator,seed);
  }
  public function concat<T>(src1:Observable<T>):Observable<T>{
    return Observables.concat(this,src1);
  }
  public function aggregate(accumulator:T->T->T,?seed:T):Observable<T>{
    return Observables.aggregate(this,accumulator,seed);
  }
  public function startWith(values:Array<T>,?scheduler):Observable<T>{
    return Observables.startWith(this,values);
  }
  public function last():Observable<T>{
    return Observables.last(this);
  }
  /*
  @:from static public function fromContinuation<T>(cnt:Continuation<Dissolvable,Chunk<T>>):Observable<T>{
    var ct : ContinuationType<Dissolvable,Chunk<T>>  = cnt;
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
  public function each(fn:Chunk<T>->Void):Dissolvable{
    return Observables.each(this,fn);
  }
  */
}
class Observables{
  static public function buffer<A>(source:Observable<A>):Observable<A>{
    return new BufferedObservable(source);
  }
  static public function map<A,B>(source:Observable<A>,fn:A->B):Observable<B>{
    return function(o:Observer<B>):Dissolvable{
      return source.subscribe(
        function(chk:Chunk<A>){
          switch (chk) {
            case Val(v) : o.onData(fn(v));
            case End(e) : o.onFail(e);
            case Nil    : o.onDone();
          }
        }
      );
    }
  }
  static public function filter<A>(source:Observable<A>,selector:A->Bool):Observable<A>{
    return function(observer:Observer<A>){
      var count = 0;
      return source.subscribe(
        function(chk:Chunk<A>){
          switch(chk){
            case Val(v) : 
              if (selector(v)){
                observer.onData(v);
              }
            case End(e) : observer.onFail(e);
            case Nil    : observer.onDone();
          }
        }
      );
    }
  }
  /*static public function any<A>(source:Observable<A>,selector:A->Bool):Observable<A>{
    return filter(source,
      function(x)
    )
  }*/
  /*static public function all<A>(source:Observable<A>,selector:A->Bool):Observable<Bool>{

  }*/
  static public function each<A>(source:Observable<A>,fn:Chunk<A>->Void){
    return source.subscribe(fn);
  }
  static public function scan1<A>(source:Observable<A>,accumulator:Reduce<A,A>,?seed:A):Observable<A>{
    var hasSeed = option(seed).isDefined();
    return function(observer:Observer<A>):Dissolvable{
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
  static public function merge<T>(source0:Observable<T>,source1:Observable<T>):Observable<T>{
    return function(observer:Observer<T>){
      var done  = false;
      var error = false;
      var count = 0;
      function handler(chk:Chunk<T>){
       switch(chk){
          case Val(v) : if(!error){ observer.onData(v); }
          case End(e) : 
            error = true; 
            done  = true;
            observer.onFail(e);
            observer.onDone();
          case Nil    : count++;
          if(count == 2 && (!error || !done)){
            done = true;
            observer.onDone();
          }
        }
      }
      var dsp0 = source0.subscribe(handler);
      var dsp1 = source1.subscribe(handler);

      return new AnonymousDissolvable(function(){
        dsp0.dissolve();
        dsp1.dissolve();
      });
    }
  }
  static public function concat<T>(source0:Observable<T>,source1:Observable<T>):Observable<T>{
    return function (observer:Observer<T>){
      var error = false;
      var disp  = new CompositeDissolvable();
      disp.add(
        source0.subscribe(
          function(chk:Chunk<T>){
            switch(chk){
              case Val(v) : if(!error){
                observer.onData(v);
              }
              case End(e) : error = true; 
                observer.onFail(e);
                observer.onDone();
              case Nil    : if(!error){
                disp.add(
                  source1.subscribe(
                    function(chk){
                      switch(chk){
                        case Val(v) : if(!error) observer.onData(v);
                        case End(e) : error = true; observer.onFail(e); observer.onDone();
                        case Nil    : observer.onDone();
                      }
                    }
                  )
                );
              }
            }
          }
        )
      );
      return disp;
    }
  }
  static public function aggregate<T>(source:Observable<T>,accumulator:T->T->T,?seed:T):Observable<T>{
    return last(startWith(scan1(source, accumulator, seed), seed == null ? [] : [seed]));
  }
  static public function startWith<T>(source:Observable<T>,values:Array<T>,?scheduler):Observable<T>{
    scheduler = scheduler == null ? inject(Scheduler) : scheduler;
    return function(obs:Observer<T>):Dissolvable{
      var dis               = new Dispatcher();
      var col               = new CompositeDissolvable();
      var rct               = reactive(dis,values.map(Val),scheduler);
      source.subscribe(
        function(v:Chunk<T>):Dissolvable{
          dis.emit(v);
          return new NullDissolvable();
        }
      );
      return rct(obs.apply);
    }
  }
  static public function last<T>(source:Observable<T>){
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
  static public function observable<T>(evt:Eventual<T>):Observable<T>{
    return new EventualObservable(evt);
  }
}
@doc("Observe the Outcome of a Contract.")
class ContractObservables{
  static public function observable<T>(evt:Contract<T>):Observable<T>{
    return new ContractObservable(evt);
  } 
}
@doc("Observe values emitted by a Reactor.")
class ReactorChunkObservables{
  static public function observable<T>(rct:Reactor<Chunk<T>>):Observable<T>{
    return new ReactorChunkObservable(rct);
  }
}
class DispatcherChunkObservables{
  static public function observable<T>(rct:Dispatcher<Chunk<T>>):Observable<T>{
    return new DispatcherChunkObservable(rct);
  }
}
class IterableChunkObservables{
  static public function observable<T>(itr:Iterable<Chunk<T>>):Observable<T>{
    return new IterableChunkObservable(itr);
  }
}
class IterableObservables{
  static public function observable<T>(itr:Iterable<T>):Observable<T>{
    return new IterableObservable(itr);
  }
}