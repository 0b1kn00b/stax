package rx.deferred;

import stx.Fail;
import Prelude;
import Stax.*;
import rx.ifs.Waiting;

using stx.Arrays;
using stx.Option;

import rx.Callback;

import rx.Future in AFuture;

class Future<T> implements Waiting<Callback<T>>{

  private var handlers    : Array<Callback<T>>;
  private var data        : Option<T>;

  public function new(){
    this.data       = None;
    this.handlers   = [];
  }
  public function subscribe(callback:Callback<T>):Disposable{ 
    return if(handlers.find(callback).isDefined()){
      noop;
    }else{
      var cancelled   = false;
      var callback0 : Callback<T>    
      = function(x){
          if(!cancelled){
            callback.apply(x);
          }
        }
        var disposable  = function(){
          cancelled = true;
        }
      switch (data) {
        case Some(v)  : callback0.apply(v); 
        case None     : handlers.unshift(callback0);
      }
      disposable;
    }
  }
  public function deliver(v:T){
    if(data.isDefined()){
      except()(IllegalOperationError('Future delivered twice'));
    }else{
      handlers.each(Callbacks.apply.bind(_,v));
      data = Some(v);
    }
  }
  public function each(fn:T->Void):AFuture<T>{
    return this.map(
      function(x){
        fn(x);
        return x;
      }
    );
  }
  public function map<U>(fn:T->U):AFuture<U>{
    var ft = new Future();
    var ds = 
      this.subscribe(
        function(x){
          ft.deliver(fn(x));
        }
      );
    return ft;
  }
  public function flatMap<U>(fn:T->AFuture<U>):AFuture<U>{
    var fn0 = new AFuture();
    this.subscribe(
      function(x:T){
        var fn1 = fn(x);
            fn1.subscribe(fn0.deliver);
      }
    );
    return fn0;
  }
}