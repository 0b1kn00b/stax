package stx.reactive;

import stx.Chunk;

using stx.Arrays;

import stx.async.Dissolvable;
import stx.async.dissolvable.AnonymousDissolvable;

import hx.ifs.Scheduler;

import hx.reactive.Dispatcher;

import stx.ioc.Inject.*;

class Rx{
  static public function reactive<T>(?rct:Dispatcher<T>,?stack:Array<T>,?scheduler:Scheduler):(T->Void)->Dissolvable{
    scheduler = scheduler == null ? inject(Scheduler) : scheduler;
    stack     = stack     == null ? [] : stack;
    if(rct!=null){
      rct.add(stack.push);
    }
    return function(fn:T->Void):Dissolvable{
      var cancelled = false;
      function cancel():Void{
        cancelled = true;
      }
      function handler(v:T):Void{
        if(!cancelled){
          scheduler.immediate(function(){fn(v);});
        }
      }
      stack.each(handler);
      if(rct!=null){
        rct.add(handler);
      }
      return new AnonymousDissolvable(cancel);
    }
  }
  static public function extension<T>(fn:(T->Void)->Dissolvable,selector:T->Bool):Observable<T>{
    return function(observer:Observer<T>):Dissolvable{
      var cancelled     = false;
      var cancel_stack : Array<Dissolvable> = [];
      var handler = function(v:T):Void{
        if(!cancelled){
          cancelled = selector(v);
          if(cancelled){
            cancel_stack.each(function(x) x.dissolve() );
            observer.onDone();
          }else{
            observer.onData(v);
          }
        }
      }
      var disp : Dissolvable = fn(handler);
      cancel_stack.push(disp);
      return disp;
    }
  }
}