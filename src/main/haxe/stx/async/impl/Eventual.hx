package stx.async.impl;

import stx.async.dissolvable.*;
import stx.async.Dissolvable;
import stx.async.Callback;

import stx.Fail;
import Prelude;
import Stax.*;
import stx.async.ifs.Waiting;

using stx.Arrays;
using stx.Option;

import stx.async.Callback;

import stx.async.Eventual in AEventual;

class Eventual<T> implements Waiting<Callback<T>>{

  private var handlers    : Array<Callback<T>>;
  private var data        : Option<T>;

  public function new(){
    this.data       = None;
    this.handlers   = [];
  }
  public function subscribe(callback:Callback<T>):Dissolvable{ 
    return if(handlers.find(callback).isDefined()){
      new NullDissolvable();
    }else{
      var cancelled   = false;
      var callback0 : Callback<T>    
      = function(x){
          if(!cancelled){
            callback.apply(x);
          }
        }
        var dissolvable  = new AnonymousDissolvable(function(){
          cancelled = true;
        });
      switch (data) {
        case Some(v)  : callback0.apply(v); 
        case None     : handlers.unshift(callback0);
      }
      dissolvable;
    }
  }
  public function deliver(v:T):Eventual<T>{
    if(data.isDefined()){
      except()(IllegalOperationError('Eventual delivered twice'));
    }else{
      handlers.each(Callbacks.apply.bind(_,v));
      data = Some(v);
    }
    return this;
  }

  public var delivered(get,null) : Bool;
  private function get_delivered():Bool{
    return data.isDefined();
  }

  public function each(fn:T->Void):AEventual<T>{
    return this.map(
      function(x:T):T{
        fn(x);
        return x;
      }
    );
  }
  
  public function map<U>(fn:T->U):AEventual<U>{
    var ft : AEventual<U> = new AEventual(new Eventual());
    var ds = 
      this.subscribe(
        function(x){
          ft.deliver(fn(x));
        }
      );
    return ft;
  }
  
  public function flatMap<U>(fn:T->AEventual<U>):AEventual<U>{
    var fn0 = new AEventual();
    this.subscribe(
      function(x:T){
        var fn1 = fn(x);
            fn1.subscribe(fn0.deliver);
      }
    );
    return fn0;
  }
  public function zipWith<U,V>(evt2:AEventual<U>,fn:T->U->V):AEventual<V>{
    var fn0 = new AEventual();
    this.subscribe(
     function(t:T){
        evt2.subscribe(
          function(u:U){
            fn0.deliver(fn(t,u));
          }
        );
     } 
    );
    return fn0;
  }
  public function val(){
    return switch (data) {
      case None     : return except()(NullError());
      case Some(v)  : v;
    }
  }
}