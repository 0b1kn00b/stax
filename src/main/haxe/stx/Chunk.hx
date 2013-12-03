package stx;

import Stax.*;

import stx.type.*;
import stx.Tuples.*;
import stx.Fail;

using stx.Arrays;
using Prelude;
using stx.Option;
using stx.Either;
using stx.Tuples;
using stx.Compose;


using stx.Chunk;

enum Chunk<V>{
  Val(v:V);
  Nil;
  End(?err:Fail);
}
class Chunks{
  @:noUsing static public function create<A>(?c:A):Chunk<A>{
    return (c == null) ? Nil : Val(c);
  }
  @doc('Produces a `Chunk` of `Array<A>` only if all chunks are defined.')
  static public inline function all<A>(chks:Array<Chunk<A>>,?nilFail:Fail):Chunk<Array<A>>{
    return chks.foldLeft(
        Val([]),
        function(memo,next){
          return switch ([memo,next]) {
            case [Val(memo),Val(next)]  : Val(memo.add(next));
            case [Val(memo),End(e)]     : End(e);
            case [Val(v),Nil]           : nilFail == null ? Nil : End(nilFail);
            case [End(e),End(e0)]       : End(e.append(e0));
            case [End(e),Nil]           : End(e.append(nilFail));
            case [End(e),_]             : End(e);
            case _                      : nilFail == null ? Nil : End(nilFail);
          }
        }
      );
  }
  static public function sure<A>(chk:Chunk<A>):Option<A>{
    return switch (chk) {
      case Val(v) : option(v);
      case Nil    : None;
      case End(e) : throw e; None;
    }
  }
  static public function fold<A,Z>(chk:Chunk<A>,val:A->Z,ers:Null<Fail>->Z,nil:Void->Z):Z{
    return switch (chk) {
      case Val(v) : val(v);
      case End(e) : ers(e);
      case Nil    : nil();
    }
  }
  static public function toOptionOutcome<A>(c:Chunk<A>){
    return switch (c){
      case Nil      : Right(None);
      case Val(v)   : Right(Some(v));
      case End(err) : err == null ? Right(None) : Left(Some(err));
    }
  }
  static public function toOutcome<A>(c:Chunk<A>){
    return switch (c){
      case Nil      : Right(null);
      case Val(v)   : Right(v);
      case End(err) : Left(err);
    }
  }
  static public function map<A,B>(chunk:Chunk<A>,fn:A->B):Chunk<B>{
    return switch (chunk){
      case Nil      : Nil;
      case Val(v)   : 
        var o = fn(v);
        create(o);
      case End(err) : End(err);
    }
  }
  static public function flatten<A>(chk:Chunk<Chunk<A>>):Chunk<A>{
    return flatMap(chk,
      function(x:Chunk<A>){
        return x;
      }
    );
  }
  static public function flatMap<A,B>(chunk:Chunk<A>,fn:A->Chunk<B>):Chunk<B>{
    return switch (chunk){
      case Nil      : Nil;
      case Val(v)   : fn(v);
      case End(err) : End(err);
    }
  }
  static public function recover<A,B>(chunk:Chunk<A>,fn:Fail -> Chunk<A> ):Chunk<A>{
    return switch (chunk){
      case Nil      : Nil;
      case Val(v)   : Val(v);
      case End(err) : fn(err);
    }
  }
  static public function zipWith<A,B,C>(chunk0:Chunk<A>,chunk1:Chunk<B>,fn:A->B->C):Chunk<C>{
    return switch (chunk0){
      case Nil      : Nil;
      case Val(v)   :
        switch (chunk1){
          case Nil      : Nil;
          case Val(v0)  : Chunks.create(fn(v,v0));
          case End(err) : End(err);
        }
      case End(err) :
        switch (chunk1){
          case End(err0)  : End(err.append(err0));
          default         : Nil;
        }
    }
  }
  static public function zip<A,B>(chunk0:Chunk<A>,chunk1:Chunk<B>):Chunk<Tuple2<A,B>>{
    return zipWith(chunk0,chunk1,tuple2);
  }
  static public function zipN<A>(rest:Array<Chunk<A>>):Chunk<Array<A>>{
    return rest.foldLeft(
      Val([]),
      function(memo,next){
        return switch (memo) {
          case Val(xs) : switch (next) {
            case Val(x) : Val(xs.add(x));
            case Nil    : Val(xs);
            case End(e) : End(e);
          }
          default       : memo;
        }
      }
    );
  }
  static public function zipOptionWith<A,B,C>(chunk0:Chunk<A>,chunk1:Chunk<B>,fn:Option<A>->Option<B>->Option<C>):Chunk<C>{
    return switch (chunk0){
      case Nil      :
        switch (chunk1){
          case Nil      : fn(None,None).map(Chunks.create).valOrUse(Nil);
          case Val(v)   : fn(None,Some(v)).map(Chunks.create).valOrUse(Nil);
          case End(err) : End(err);
        }
      case Val(v)   :
        switch (chunk1){
          case Nil      : fn(Some(v),None).map(Chunks.create).valOrUse(Nil);
          case Val(v0)  : fn(Some(v),Some(v0)).map(Chunks.create).valOrUse(Nil);
          case End(err) : End(err);
        }
      case End(err) :
        switch (chunk1){
          case End(err0) if(err0!=null) : End(err.append(err0));
          default                       : End(err);
        }
    }
  }
  static public function getOutcomeOrC<A>(chk:Chunk<A>,n:A):Outcome<A>{
    return switch (chk){
      case Nil      : Success(n);
      case Val(v)   : Success(v);
      case End(err) : Failure(err);
    }
  }
  static public function orChunkErrC<A>(myb:Option<A>,err:Fail):Chunk<A>{
    return switch (myb){
      case Some(v)  : Val(v);
      case None     : End(err);
    }
  }
  static public function orChunkNil<A>(myb:Option<A>):Chunk<A>{
    return switch (myb){
      case Some(v)  : Val(v);
      case None     : Nil;
    }
  }
  static public function asChunkEnd<A>(myb:Option<Fail>):Chunk<A>{
    return switch (myb){
      case Some(v)  : End(v);
      case None     : Nil;
    }
  }
  static public function orElseConst<A>(chk:Chunk<A>,v:A):Chunk<A>{
    return switch (chk){
      case Nil      : Chunks.create(v);
      case Val(v)   : Val(v);
      case End(err) : End(err);
    }
  }
  static public function valueOption<A>(chk:Chunk<A>):Option<A>{
    return switch (chk){
      case Nil      : None;
      case Val(v)   : Some(v);
      case End(_)   : None;
    }
  }
  static public function value<A>(chk:Chunk<A>):Null<A>{
    return switch (chk){
      case Nil      : null;
      case Val(v)   : v;
      case End(_)   : null;
    }
  }
  static public function fail<A>(chk:Chunk<A>):Null<Fail>{
    return switch (chk){
      case Nil      : null;
      case Val(_)   : null;
      case End(er)  : er;
    }
  }
  static public function isDefined<A>(chk:Chunk<A>):Bool{
    return fold(chk,
      Compose.pure(true),
      Compose.pure(false),
      function() return false
    );
  }
  static public function success<A>(chk:Chunk<A>,fn:A->Void):Chunk<A>{
    switch (chk) {
      case Val(v) : fn(v);
      default     : 
    }
    return chk;
  }
  static public function failure<A>(chk:Chunk<A>,fn:Null<Fail>->Void):Chunk<A>{
    switch (chk) {
      case End(v) : fn(v);
      default     : 
    }
    return chk;
  }
  static public function nothing<A>(chk:Chunk<A>,fn:Void->Void):Chunk<A>{
    switch (chk) {
      case Nil    : fn();
      default     : 
    }
    return chk;
  }
  static public function toVouch<A>(chk:Chunk<A>):Vouch<A>{
    return stx.Eventual.pure(chk);
  }
}