package stx.async.arrowlet;

import stx.Fail;
import Prelude;
import stx.async.Eventual;

using stx.Tuples;
using stx.Option;
using stx.async.Arrowlet;
using stx.Compose;

using stx.Vouch;
using stx.Chunk;

typedef SpawnType<T> = Arrowlet<Unit,Chunk<T>>;

abstract Spawn<T>(SpawnType<T>) from SpawnType<T> to SpawnType<T>{
  static public inline function spawn<T>(arw):Spawn<T>{
    return new Spawn(arw);
  }
  @:noUsing static public function pure<T>(v:T):Spawn<T>{
    return Arrowlet.pure(Val(v));
  }
  @:noUsing static public function unit<T>():Spawn<T>{
    return function(u:Unit) return Nil;
  }
  public function new(v){
    this = v;
  }
  public function edit<B>(arw:Arrowlet<T,B>):Spawn<B>{
    return this.then(
      function(chk:Chunk<T>):Eventual<Chunk<B>>{
        return chk.fold(
          arw.then(Val).apply,
          function(x) return Vouches.breach(x),
          Vouches.empty
        );
      }
    );
  }
  public function attempt<B>(arw:Arrowlet<T,Chunk<B>>):Spawn<B>{
    return this.then(
      function(chk:Chunk<T>){
        return chk.fold(
          arw.apply,
          function(x) return Vouches.breach(x),
          Vouches.empty
        );
      }
    );
  }
  public function split<B>(spn1:SpawnType<B>):Spawn<Tuple2<T,B>>{
    return new Spawn(Arrowlets.split(this,spn1).then(Chunks.zip));
  }
  public function breakoutUsing(er:Null<Fail>->T,nil:Void->T):Arrowlet<Unit,T>{
    return function(x:Unit):Eventual<T>{
      return Arrowlets.then(this,
        function(chk:Chunk<T>){
          return chk.fold(
            Compose.unit(),
            er,
            nil
          );
        }
      ).apply(x);
    }
  }
  public function toCrank<B>():Crank<B,T>{
    return function(x:Chunk<B>){
      return this.apply(Unit);
    }.lift();
  }
}
class Spawns{
  public function edit<A,B>(spn:SpawnType<A>,arw:Arrowlet<A,B>):Spawn<B>{
    return new Spawn(spn).edit(arw);
  }
  public function attempt<A,B>(spn:SpawnType<A>,arw:Arrowlet<A,Chunk<B>>):Spawn<B>{
    return new Spawn(spn).attempt(arw);
  }
  static public function split<A,B>(spn0:SpawnType<A>,spn1:Spawn<B>):Spawn<Tuple2<A,B>>{
    return new Spawn(spn0).split(spn1);
  }
  public function breakoutUsing<A>(arw:SpawnType<A>,er:Null<Fail>->A,nil:Void->A):Arrowlet<Unit,A>{
    return new Spawn(arw).breakoutUsing(er,nil);
  }
  static public function toCrank<A,A,B>(spn:SpawnType<A>):Crank<B,A>{
    return new Spawn(spn).toCrank();
  }
}