package stx.async.arrowlet.avm2;

import Stax.*;
import Prelude;

using stx.async.Arrowlet;
using stx.Functions;
using stx.Tuples;

import stx.async.dissolvable.AnonymousDissolvable;
import stx.reactive.Handler;

import flash.events.Event in FlashEvent;
import flash.events.IEventDispatcher;

abstract Event<T:FlashEvent>(Arrowlet<IEventDispatcher,T>) from Arrowlet<IEventDispatcher,T> to Arrowlet<IEventDispatcher,T>{
  public function new(v){
    this = v;
  }
  static public function pure<T:FlashEvent>(str:String):Event<T>{
    return fromString(str);
  }
  @:from static public function fromString<T:FlashEvent>(str:String):Event<T>{
    return function(dispatcher:IEventDispatcher,cont:T->Void):Void{
      Events.once(dispatcher,str,cont);
    }
  }
}
class Events{
  static public function once<T:FlashEvent>(dispatcher:IEventDispatcher,key:String,fn:T->Void):Void{
    function handler(e:T){
      fn(e);
      dispatcher.removeEventListener(key,handler);
    }
    dispatcher.addEventListener(key,handler);
  }
  static public function project<T>(arw:Arrowlet<IEventDispatcher,T>):IEventDispatcher->Handler<T>{
    return function(dispatcher:IEventDispatcher):Handler<T>{
      return function(cb:T->Void):Dissolvable{
        var done        = false;
        var dissolvable = new AnonymousDissolvable(function(){
          done = true;
        });
        arw.augure(dispatcher).apply(printer());
        arw.tie(tuple2).then(
          function(l:IEventDispatcher,r:T){
            trace('here');
            cb(r);
            return done ? Done(Unit) : Cont(l);
          }.tupled()
        ).repeat().augure(dispatcher).apply(noop1);
        return dissolvable;
      }
    }
  }
}