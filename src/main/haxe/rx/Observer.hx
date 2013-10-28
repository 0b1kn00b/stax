package stx.rx;

import stx.Prelude;
import Stax.*;
import stx.Chunk;

import stx.rx.disposable.*;
import stx.rx.observer.*;
import stx.rx.ifs.Observer in IObserver;

typedef ObserverType<T> = IObserver<T>;

@doc("")
abstract Observer<T>(ObserverType<T>) from ObserverType<T> to ObserverType<T>{
  public function new(v){
    this = v;
  }
  public function apply(chk:Chunk<T>):Void{
    this.apply(chk);
  }
  public function data(v:T):Void{
    this.data(v);
  }
  public function fail(v:Fail):Void{
    this.fail(v);
  }
  public function done():Void{
    this.done(Nil);
  }
  @:from static public function fromChunkCallback<T>(fn:Chunk<T>->Void):Observer<T>{
    return new AnonymousObserver(function(chk:Chunk<T>):Void{
      fn(chk);
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
        case Val(v) : this.data(fn(v));
        case End(e) : this.fail(e);
        case Nil    : this.done(Nil);
      }
    }
  }
}
class ChunkObservers{
  static public function asObserver<A>(fn:Chunk<A>->Void):Observer<A>{
    return fn;
  }
}