package rx;

import stx.Chunk;
import stx.Fail;
import Prelude;
import Stax.*;

import rx.disposable.*;
import rx.observer.*;
import rx.ifs.Observer in IObserver;

@doc("")
abstract Observer<T>(IObserver<T>) from IObserver<T> to IObserver<T>{
  static public function unit<T>(){
    return function(chk:Chunk<T>){}
  }
  public function new(v){
    this = v;
  }
  public function apply(chk:Chunk<T>):Void{
    this.apply(chk);
  }
  public function onData(v:T):Void{
    this.onData(v);
  }
  public function onFail(v:Fail):Void{
    this.onFail(v);
  }
  public function onDone():Void{
    this.onDone();
  }
  @:from static public function fromChunkCallback<T>(fn:Chunk<T>->Void):Observer<T>{
    return new AnonymousObserver(function(chk:Chunk<T>):Void{
      fn(chk);
    });
  }
  @:from static public function fromEndCallback<T>(fn:Fail->Void):Observer<T>{
    return new AnonymousObserver(function(chk:Chunk<T>):Void{
      switch (chk) {
        case End(e) : fn(e);
        default :
      }
    });
  }
  @:from static public function fromTCallback<T>(fn:T->Void):Observer<T>{
    return new AnonymousObserver(function(chk:Chunk<T>):Void{
      switch (chk) {
        case Val(v) : fn(v);
        default :
      }
    });
  }
  @:from static public function fromNilCallback<T>(fn:Void->Void):Observer<T>{
    return new AnonymousObserver(function(chk:Chunk<T>):Void{
      switch (chk) {
        case Nil : fn();
        default:
      }
    });
  }
  public function filter(fn:Chunk<T>->Bool):Observer<T>{
    return function(chk:Chunk<T>):Void{
      if(fn(chk)){
        this.apply(chk);
      }
    }
  }
  @:note('#0b1kn00b: Not sure what this is but it makes sense.')
  public function mapi<U>(fn:U->T):Observer<U>{
    return function(chk:Chunk<U>):Void{
      return switch (chk) {
        case Val(v) : this.onData(fn(v));
        case End(e) : this.onFail(e);
        case Nil    : this.onDone();
      }
    }
  }
}
class ChunkObservers{
  static public function asObserver<A>(fn:Chunk<A>->Void):Observer<A>{
    return fn;
  }
}