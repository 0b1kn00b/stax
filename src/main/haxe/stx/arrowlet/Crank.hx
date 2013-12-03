package stx.arrowlet;

import Stax.*;
import stx.Compare.*;

import stx.Outcome;
import stx.Eventual;
import stx.Tuples.*;
import stx.plus.Order;
import Prelude;
import stx.Fail;

import stx.arrowlet.State;

using stx.Tuples;

using stx.Arrowlet;

using stx.Reflects;
using stx.Option;
using stx.Compose;
using stx.Anys;
using stx.Arrays;
using stx.Either;
using stx.Tuples;
using Prelude;
using stx.Option;

using stx.Objects;
using stx.Types;
using stx.Arrowlet;
//using stx.Compose;

using stx.Chunk;
using stx.Vouch;


typedef ArrowletCrank<I,O> = Arrowlet<Chunk<I>,Chunk<O>>;

abstract Crank<I,O>(ArrowletCrank<I,O>) from ArrowletCrank<I,O> to ArrowletCrank<I,O>{
  static inline public function wrap<A,B>(a:Crank<A,B>,v:A):Crank<Unit,B>{
    return function(x:Unit){
      return a.imply(v);
    };
  }
  @:noUsing static public function pure<T>(v:T):Crank<T,T>{
    return Arrowlet.pure(Chunks.create(v));
  }
  static public function crank<A,B>(?v:ArrowletCrank<A,B>):Crank<A,B>{
    return new Crank(v);
  }
  @:from static public function fromToChunk<A,B>(arw:Arrowlet<A,Chunk<B>>){
    return function(chk:Chunk<A>){
      return switch (chk){
        case Nil      : Eventual.pure(Nil);
        case Val(v)   : arw.apply(v);
        case End(err) : Eventual.pure(End(err));
      }
    };
  }
  @:from static public function fromArrowlet<A,B>(arw:Arrowlet<A,B>):Crank<A,B>{
    return function(chk:Chunk<A>):Eventual<Chunk<B>>{
      return switch (chk){
        case Nil      : Eventual.pure(Nil);
        case Val(v)   : arw.apply(v).map(Chunks.create);
        case End(err) : Eventual.pure(End(err));
      } 
    };
  }
  @:from static public function fromOutcomeArrowlet<A,B>(arw:Arrowlet<A,Outcome<B>>):Crank<A,B>{
    return function(x:Chunk<A>){
      return switch (x){
        case Nil      : Eventual.pure(Nil);
        case Val(v)   : arw.apply(v).map(stx.Outcomes.toChunk);
        case End(err) : err.breach();
      }
    };
  }
  public function new(?v:ArrowletCrank<I,O>){
    this = nl().apply(v) ? 
      function(x:Chunk<I>):Chunk<O>{
        return cast ( (x == null) ? End(fail(NullReferenceFail(''))) : x );
      } : v;
  }  
  public function asArrowlet():ArrowletCrank<I,O>{
    return this;
  }
  public function maybe<N>(arw:Arrowlet<Option<O>,Chunk<N>>):Crank<I,N>{
    return this.then(
      function(x:Chunk<O>){
        return switch (x){
          case Nil      : arw.apply(None);
          case Val(v)   : arw.apply(Some(v));
          case End(err) : Eventual.pure(End(err));
        }
      }
    );
  }
  public function fill<N>(arw:ArrowletCrank<Unit,N>):Crank<I,N>{
    return this.then(
      function(x:Chunk<O>):Eventual<Chunk<N>>{
        return switch (x){
          case Nil      : arw.apply(Val(Unit));
          case Val(_)   : Eventual.pure(End(fail(AssertionFail('Nil','Val'))));
          case End(err) : Eventual.pure(End(err));
        };
      }
    );  
  }
  public function orElse(arw:ArrowletCrank<Unit,O>):Crank<I,O>{
    return this.then(
      function(x){
        return switch (x){
          case Nil      : arw.apply(Val(Unit));
          case Val(v)   : Eventual.pure(Val(v));
          case End(err) : Eventual.pure(End(err));
        };
      }
    );
  }
  public function orElseConst(v:O):Crank<I,O>{
    return this.then(
      function(x){
        return switch (x){
          case Nil      : Val(v);
          case Val(v)   : Val(v);
          case End(err) : End(err);
        };
      }
    );
  }
  public function process(arw:Arrowlet<O,Chunk<Bool>>,?e):Crank<I,O>{
    return this.then(kwv.arw.Process.process(arw,e));
  }
  public function operate(arw:Arrowlet<O,Option<Fail>>):Crank<I,O>{
    return this.then(kwv.arw.Process.operate(arw));
  }
  public function attempt<N>(arw:Arrowlet<O,Chunk<N>>):Crank<I,N>{
    return this.then(
      function(x){
        return switch (x){
          case Nil      : Eventual.pure(Nil);
          case Val(v)   : arw.apply(v);
          case End(err) : Eventual.pure(End(err));
        }
      }
    );
  }
  public function nilFail(?e:Fail,?pos):Crank<I,O>{
    e = nl().apply(e) ? fail(NullReferenceFail('',pos)) : e;
    return this.then(
      function(x){
        return switch (x){
          case Nil      : End(e);
          case Val(v)   : Val(v);
          case End(err) : End(err);
        };
      }
    );
  }
  public function split<N>(arw:Crank<I,N>):Crank<I,Tuple2<O,N>>{
    return this.split(arw).then(Chunks.zip.tupled());
  }
  public function join<N>(arw:Crank<O,N>):Crank<I,Tuple2<O,N>>{
    return this.join(arw).then(Chunks.zip.tupled()); 
  }
  public function then<N>(arw:Crank<O,N>):Crank<I,N>{
    return this.then(arw);
  }
  public function asMill():Windmill<I,O>{
    return new Windmill(
      function(s:I):Eventual<Tuple2<Chunk<O>,I>>{
        return imply(this,s).asEventual().map(tuple2.bind(_,s));
      }
    );
  }
  public function request<N>(m:Windmill<N,Bool>,ipt:N):Crank<I,O>{
    return process(
      function(x:O){
        return StateArrowlets.request(m,ipt);
      }
    );
  }
  public function processWithOrErr<N,M>(crk:O -> Windmill<N,Bool>,n:N,?e:Fail):Crank<I,O>{
    e = nl().apply(e) ? fail(Failed('Failure at processWithOrErr')) : e;
    return attempt(
      function(y:O){
        return StateArrowlets.request(crk(y),n).map(
          function(chk:Chunk<Bool>){
            return switch (chk){
              case Nil      : Nil;
              case Val(v)   : v ? Val(y) : End(e);
              case End(err) : End(err);
            }
          }
        );
      }
    );
  }
  public function imply(v:I):Vouch<O>{
    return this.apply(Chunks.create(v));
  }
}
class CranksMore{
  static public function toCrank<A,B>(arw:Arrowlet<A,Outcome<B>>):Crank<A,B>{
    return Crank.fromOutcomeArrowlet(arw);   
  }
}
class Cranks{
  static public function attempt<I,O,N>(arw0:Crank<I,O>,arw:Arrowlet<O,Chunk<N>>):Crank<I,N>{
    return arw0.attempt(arw);
  }
  static public function edit<I,O,N>(arw0:Crank<I,O>,arw1:Arrowlet<O,N>):Crank<I,N>{
    return arw0.then( 
      function(x){
        return switch (x){
          case Nil      : Eventual.pure(Nil);
          case Val(v)   : arw1.apply(v).map(Chunks.create);
          case End(err) : Eventual.pure(End(err));
        }
      }
    );
  }
  static public function tie<I,O,N>(arw0:Crank<I,O>,arw1:Arrowlet<Tuple2<I,O>,Chunk<N>>):Crank<I,N>{
    return Arrowlets.tie(arw0,
      function(chk0:Chunk<I>,chk1:Chunk<O>):Vouch<N>{
        return switch(chk0.zip(chk1)){
          case Val(t2)  : arw1.apply(t2);
          case Nil      : Eventual.pure(Nil);
          case End(e)   : Eventual.pure(End(e));
        }
      }.tupled()
    );
  }
  static public function split<I,O,P>(arw0:Crank<I,O>,arw1:ArrowletCrank<I,P>):Crank<I,Tuple2<O,P>>{
    return arw0.split(arw1);
  }
  static public function pair<I,O,P,Q>(arw0:Crank<I,O>,arw1:Crank<P,Q>):Crank<Tuple2<I,P>,Tuple2<O,Q>>{
    return function(tp:Chunk<Tuple2<I,P>>):Eventual<Chunk<Tuple2<O,Q>>>{
      var l : Chunk<I> = tp.map(Tuples2.fst);
      var r : Chunk<P> = tp.map(Tuples2.snd);
      return arw0.apply(l).zip(arw1.apply(r)).map(Chunks.zip.tupled());
    }
  }
/*  static public function first<I,O,P>(arw0:Crank<I,O>):Crank<Tuple2<I,P>,Tuple2<O,P>>{
    return pair(arw0,function(x:Chunk<P>) return x);
  }*/
  static public function then<A,B,C>(before:Crank<A,B>, after:ArrowletCrank<B,C>):Crank<A,C> { 
    return before.then(after);
  }
  static public function join<A,B,C>(joinl:Crank<A,B>,joinr:ArrowletCrank<B,C>):Crank<A,Tuple2<B,C>>{
    return then(joinl, split(Arrowlet.unit(),joinr));
  }
  static public function action<I,O>(arw0:Crank<I,O>,action:O->Void):Crank<I,O>{
    return Cranks.edit(arw0,
      function(x){
        action(x);
        return x;
      }
    );
  }
  public static function exchange<I,O,N>(a:Crank<I,O>,n:N):Crank<I,N>{
    return a.then(
      function(x){
        return Chunks.create(n);
      }
    );
  }
  static public function reply<O>(arw:Crank<Unit,O>){
    return arw.imply(Unit);
  }
  static public function valued<A,B>(arw:Arrowlet<A,B>):Crank<A,B>{
    return Crank.fromArrowlet(arw);
  }
  /*static public function toCrank<A,B>(arw:ArrowletOutcome<A,B>):Crank<A,B>{
    return new Crank(function(x:Chunk<A>):Eventual<Chunk<B>>{
      return switch (x){
        case Nil      : Vouches.empty();
        case Val(v)   : arw.imply(v).map(stx.Outcomes.toChunk);
        case End(err) : arw.apply(Left(err)).map(stx.Outcomes.toChunk);
      }
    });
  }*/
  static public function breakout<A,B,C>(arw:Crank<A,B>,arw0:Arrowlet<Chunk<B>,C>):Arrowlet<A,C>{
    return function(x:A):Eventual<C>{
      return Arrowlets.then(arw,arw0).apply(Chunks.create(x));
    }
  }
  @doc("breakout of Crack, folding with `er` or `nil`.")
  static public function breakoutUsing<A,B>(arw:Crank<A,B>,er:Null<Fail>->B,nil:Void->B):Arrowlet<A,B>{
    return function(x:A):Eventual<B>{
      return Arrowlets.then(arw,
        function(chk:Chunk<B>){
          return chk.fold(
            Compose.unit(),
            er,
            nil
          );
        }
      ).apply(Chunks.create(x));
    }
  }
  @doc("Run the Arrowlet and produced error `e` if it returns `Val(false)`")
  static public function process<I>(arw:Arrowlet<I,Chunk<Bool>>,?e):Crank<I,I>{
    e = nl().apply(e) ? fail(ProcessFail) : e;
    return Arrowlets.tie(Crank.fromToChunk(arw),
      function(x:Chunk<I>,y:Chunk<Bool>){
        return switch (x){
          case Nil      : Nil;
          case Val(v)   : 
            switch (y){
              case Nil       : End(e);
              case Val(b)    : b ? Val(v) : Nil;
              case End(err)  : End(err);
            }
          case End(err) : End(err);
        }
      }.tupled()
    );
  }
  @doc("Perform the effect of the Arrowlet. Return the Input if successful, or any error produced.")
  static public function operate<I>(arw:Arrowlet<I,Option<Fail>>):Crank<I,I>{
    return crank(function(x:Chunk<I>){
      return switch (x){
        case Nil      : aconstant(Nil);
        case Val(v)   : arw.then(
          function(x){
            return switch (x){
              case Some(v)  : End(v);
              case None     : Val(v);
            }
          }
        );
        case End(err) : Eventual.pure(End(err));
      }
    });
  }
  @doc("run the output of `crk` with fn, producing error `e` if it fails.")  
  static public function predicate<I,O>(crk:Crank<I,O>, fn:O->Bool,?e:Fail):Crank<I,O>{
    Options.orDefault(e,err(ValidationFail('predidate failed')));
    return crk.then(
      function(chk:Chunk<O>){
        return switch (chk){
          case Nil      : End(e);
          case Val(v)   : fn(v) ? Val(v) : End(e);
          case End(err) : End(err);
        }
      }
    );
  }
  @doc("run Objects.included with the output of `crk`")
  static public function included<I,O>(crk:Crank<I,O>,keys:Array<String>):Crank<I,O>{
    return crk.then(
      operate(
        function(x:O){
          return switch(Objects.missing(x)){
            case Some(arr)  : Some(fail(PathNotFoundError));
            case None       : None;
          }
        }
      )
    );
  }
  static public function chain<I,O>(crk0:Crank<I,Bool>,crk1:Crank<I,Bool>):Crank<I,Bool>{
    return crk0.tie(
      function(i:I,b:Bool){
        return b ? crk1.imply(i) : Eventual.pure(Val(b));
      }
    );
  }
  static public function does<I,O>(crk:Crank<I,Bool>,arw:Arrowlet<Unit,Chunk<Bool>>):Crank<I,Bool>{
    return crk.attempt(
      function(b:Bool):Vouch<Bool>{
        return b ? arw.apply(Unit) : Eventual.pure(Val(b));
      }
    );
  }
}