package stx.reactive;

import stx.async.dissolvable.*;

import hx.reactive.Dispatcher;

import Prelude;
import stx.async.Dissolvable;

typedef HandlerType<T> = (T->Void)->(Dissolvable);
abstract Handler<T>(HandlerType<T>) from HandlerType<T> to HandlerType<T>{
  public function new(v){
    this = v;
  }
  @:from static public function fromDispatcher<T>(dsp:Dispatcher<T>){
    return function(fn:T->Void){
      var cancel = new AnonymousDissolvable(function(){
        dsp.rem(fn);
      });
      dsp.add(fn);

      return cancel;
    }
  }
  public function apply(fn:T->Void):Niladic{
    return this(fn);
  }
  public function map<T,U>(fn:T->U):Handler<U>{
    return Handlers.map(this,fn);
  }
}

class Handlers{
  static public function each<T>(fn0:HandlerType<T>,cb:T->Void):HandlerType<T>{
    return map(fn0,
      function(x){
        cb(x);
        return x;
      }
    );
  }
  static public function map<T,U>(fn0:HandlerType<T>,fn1:T->U):Handler<U>{
    return function(cb:U->Void):Dissolvable{
      return fn0(
        function(x:T){
          cb(fn1(x));
        }
      );
    }
  }
  static public function filter<T>(fn0:HandlerType<T>,fn1:T->Bool):Handler<T>{
    return function(cb:T->Void):Dissolvable{
      return fn0(
        function(x:T){
          if(fn1(x)){
            cb(x);
          }
        }
      );
    }
  }
  static public function foldp<T,U>(fn0:HandlerType<T>,fn:U->T->U,init:U):Handler<U>{
    return function(cb:U->Void){
      return fn0(
        function(t:T){
          init = fn(init,t);
          cb(init);
        }
      );
    }
  }
  static public function foldp1<T>(fn0:HandlerType<T>,fn:T->T->T):Handler<T>{
    return function(cb:T->Void){
      var init = null;
      return fn0(
        function(t:T){
          if(init == null){
            init = t;
          }else{
            cb(fn(init,t));
          }
        }
      );
    }
  }
  static public function merge<T>(fn0:HandlerType<T>,fn1:HandlerType<T>):Handler<T>{
    return function (cb:T->Void){
      var dsp0 = fn0(cb);
      var dsp1 = fn1(cb);
      return new AnonymousDissolvable(function(){
        dsp0.dissolve();
        dsp1.dissolve();
      });
    }
  }
  static public function combine<T>(fn:HandlerType<T>,fn1:HandlerType<T>,plus:T->T->T):Handler<T>{
    return function (cb:T->Void){
      var a = null;
      var b = null;
      function send(){
        if(a!=null && b!=null) cb(plus(a,b));
      }
      var dsp0 = fn(function(x){ a = x; send();});
      var dsp1 = fn(function(x){ b = x; send();});
      return new AnonymousDissolvable(function(){
        dsp0.dissolve();
        dsp1.dissolve();
      });
    }
  }
  //static public function withState
  /*static public function flatMap<T,U>(fn0:HandlerType<T>,fn:T->Handler<U>):Handler<U>{
    return function(cb:U->Void){
      function handler(v:T){
        fn(v).apply(cb);
      }
      return fn0(
        
      );
    }
  }*/
  /*static public function mix<T,U,V>(fn0:HandlerType<T>,fn1:HandlerType<U>,mixer:Null<V>->Null<T>->Null<U>->Either<V>,init:V):Handler<V>{
    return function(cb:V->Void){

    }
  }*/
}