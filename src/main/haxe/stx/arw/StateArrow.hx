package stx.arw;

import stx.Prelude;
import stx.Continuation.*;
import stx.Tuples;

using stx.Tuples;
using stx.arw.Arrows;
using stx.Compose;
using stx.Continuation;
using stx.arw.StateArrow;

typedef ArrowState<S,A> = Arrow<S,Tuple2<A,S>>;

class StateArrows<S,A>{
  @:noUsing
  static public function unit<S,A>():ArrowState<S,A>{
    return function(s:S):Tuple2<A,S>{
      return tuple2(null,s);
    }
  }
  static public function change<S,A>(arw0:ArrowState<S,A>,arw1:Arrow<Tuple2<A,S>,S>):ArrowState<S,A>{
    return arw0.fan().then(arw1.second())
      .then(
        function(l:Tuple2<A,S>,r:S){
          return tuple2(l.fst(),r);
        }.spread()
      );
  }
  static public function use<S,A>(arw0:ArrowState<S,A>,arw1:Arrow<S,S>):ArrowState<S,A>{
    return arw0.change(
      arw1.second().then(
        function(a:A,s:S){
          return s;
        }.spread()
      )
    );
  }
  static public function drawWith<S,A,B,C>(arw0:ArrowState<S,A>,arw1:Arrow<S,B>,fn:A->B->C):ArrowState<S,C>{
    return arw0.access(
      arw1.second().then(fn.spread())
    );
  }
  static public function draw<S,A,B>(arw0:ArrowState<S,A>,arw1:Arrow<S,B>):ArrowState<S,Tuple2<A,B>>{
    return drawWith(arw0,arw1,tuple2);
  }
  public function exchange<S,A,B>(arw0:ArrowState<S,A>,a:Arrow<S,B>):ArrowState<S,B>{
    return access(
      arw0,
      function(v:A,s:S):Eventual<B>{
        return a.apply(s);
      }
    );
  }
  static public function access<S,A,B>(arw0:ArrowState<S,A>,arw1:Arrow<Tuple2<A,S>,B>):ArrowState<S,B>{
    return arw0.join(arw1)
      .then(
        function(l:Tuple2<A,S>,r:B){
          return tuple2(r,l.snd());
        }.spread()
      );
  }
  static public function nextWith<S,A,B,C>(arw0:ArrowState<S,A>,arw1:ArrowState<S,B>,fn:A->B->C):ArrowState<S,C>{
    return arw0.then(
      function(v:A,st:S){
        return arw1.then(
          function(v0:B,st:S){
            return tuple2(fn(v,v0),st);
          }.spread()
        ).apply(st);
      }.spread()
    );
  }
  static public function next<S,A,B>(arw0:ArrowState<S,A>,arw1:ArrowState<S,B>):ArrowState<S,Tuple2<A,B>>{
    return nextWith(arw0,arw1,tuple2);
  }
  static public function split<S,A,B>(arw0:ArrowState<S,A>,arw1:ArrowState<S,B>):ArrowState<S,Tuple2<A,B>>{
    return Arrows.split(arw0,arw1).then(
      function(l:Tuple2<A,S>,r:Tuple2<B,S>):Tuple2<Tuple2<A,B>,S>{
        return tuple2(tuple2(l.fst(),r.fst()),r.snd());
      }.spread()
    );
  }
  static public function edit<S,A,B>(arw0:ArrowState<S,A>,arw1:Arrow<A,B>):ArrowState<S,B>{
    return arw0.then(
      arw1.first()
    );
  }
  static public function put<S,A>(arw0:ArrowState<S,A>,v:A):ArrowState<S,A>{
    return arw0.then(
      Compose.pure(v).first()
    );
  }
  static public function putState<S,A,B>(arw0:ArrowState<S,A>,v:S):ArrowState<S,A>{
    return arw0.then(
      Compose.pure(v).second()
    );
  }
  static public function ret<S,A>(arw0:ArrowState<S,A>):ArrowState<S,S>{
    return arw0.then(
      function(tp:Tuple2<A,S>){
        return tuple2(tp.snd(),tp.snd());
      }
    );
  }
  static public function request<S,A>(arw0:ArrowState<S,A>,i:S){
    return arw0.apply(i).map(Tuples2.fst);
  }
  static public function resolve<S,A>(arw0:ArrowState<S,A>,i:S){
    return arw0.apply(i).map(Tuples2.snd);
  }
  static public function breakout<S,A>(arw:ArrowState<S,A>):Arrow<S,A>{
    return arw.then(
      function(x:Tuple2<A,S>):A{
        return x.fst();
      }
    );
  }
}