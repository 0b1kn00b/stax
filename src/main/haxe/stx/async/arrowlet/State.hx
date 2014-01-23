package stx.async.arrowlet;

using stx.Compose;
using stx.async.Continuation;

import Prelude;
import stx.async.Continuation.*;
import stx.Tuples.Tuples2.*;

using stx.Tuples;
using stx.async.Arrowlet;


using stx.async.arrowlet.State;

typedef ArrowletState<S,A> = Arrowlet<S,Tuple2<A,S>>;

class States<S,A>{
  @:noUsing
  static public function unit<S,A>():ArrowletState<S,A>{
    return function(s:S):Tuple2<A,S>{
      return tuple2(null,s);
    }
  }
  static public function change<S,A>(arw0:ArrowletState<S,A>,arw1:Arrowlet<Tuple2<A,S>,S>):ArrowletState<S,A>{
    return arw0.fan().then(arw1.second())
      .then(
        function(l:Tuple2<A,S>,r:S){
          return tuple2(l.fst(),r);
        }.tupled()
      );
  }
  static public function use<S,A>(arw0:ArrowletState<S,A>,arw1:Arrowlet<S,S>):ArrowletState<S,A>{
    return arw0.change(
      arw1.second().then(
        function(a:A,s:S){
          return s;
        }.tupled()
      )
    );
  }
  static public function drawWith<S,A,B,C>(arw0:ArrowletState<S,A>,arw1:Arrowlet<S,B>,fn:A->B->C):ArrowletState<S,C>{
    return arw0.access(
      arw1.second().then(fn.tupled())
    );
  }
  static public function draw<S,A,B>(arw0:ArrowletState<S,A>,arw1:Arrowlet<S,B>):ArrowletState<S,Tuple2<A,B>>{
    return drawWith(arw0,arw1,tuple2);
  }
  public function exchange<S,A,B>(arw0:ArrowletState<S,A>,a:Arrowlet<S,B>):ArrowletState<S,B>{
    return access(
      arw0,
      tuple2
    );
  }
  static public function access<S,A,B>(arw0:ArrowletState<S,A>,arw1:Arrowlet<Tuple2<A,S>,B>):ArrowletState<S,B>{
    return arw0.join(arw1)
      .then(
        function(l:Tuple2<A,S>,r:B){
          return tuple2(r,l.snd());
        }.tupled()
      );
  }
  static public function nextWith<S,A,B,C>(arw0:ArrowletState<S,A>,arw1:ArrowletState<S,B>,fn:A->B->C):ArrowletState<S,C>{
    return Arrowlets.split(arw0,arw1).then(
      function(tp:Tuple2<Tuple2<A,S>,Tuple2<B,S>>){
        var tp0 = tp.fst();
        var tp1 = tp.snd();
        return tuple2(fn(tp0.fst(),tp1.fst()),tp1.snd());
      }
    );
  }
  static public function next<S,A,B>(arw0:ArrowletState<S,A>,arw1:ArrowletState<S,B>):ArrowletState<S,Tuple2<A,B>>{
    return nextWith(arw0,arw1,tuple2);
  }
  static public function split<S,A,B>(arw0:ArrowletState<S,A>,arw1:ArrowletState<S,B>):ArrowletState<S,Tuple2<A,B>>{
    return Arrowlets.split(arw0,arw1).then(
      function(l:Tuple2<A,S>,r:Tuple2<B,S>):Tuple2<Tuple2<A,B>,S>{
        return tuple2(tuple2(l.fst(),r.fst()),r.snd());
      }.tupled()
    );
  }
  static public function edit<S,A,B>(arw0:ArrowletState<S,A>,arw1:Arrowlet<A,B>):ArrowletState<S,B>{
    return arw0.then(
      arw1.first()
    );
  }
  static public function put<S,A>(arw0:ArrowletState<S,A>,v:A):ArrowletState<S,A>{
    return arw0.then(
      Compose.pure(v).first()
    );
  }
  static public function putState<S,A,B>(arw0:ArrowletState<S,A>,v:S):ArrowletState<S,A>{
    return Arrowlets.then(arw0,
      function(tp:Tuple2<A,S>){
        return tuple2(tp.fst(),v);
      }
    );
  }
  static public function ret<S,A>(arw0:ArrowletState<S,A>):ArrowletState<S,S>{
    return Arrowlets.then(arw0,
      function(tp:Tuple2<A,S>){
        return tuple2(tp.snd(),tp.snd());
      }
    );
  }
  static public function request<S,A>(arw0:ArrowletState<S,A>,i:S){
    return arw0.then(
      function(t:Tuple2<A,S>){
        return fst(t);
      }
    );
  }
  static public function resolve<S,A>(arw0:ArrowletState<S,A>,i:S){
    return arw0.then(
      function(t:Tuple2<A,S>){
        return snd(t);
      }
    );
  }
  static public function breakout<S,A>(arw:ArrowletState<S,A>):Arrowlet<S,A>{
    return arw.then(
      function(x:Tuple2<A,S>):A{
        return x.fst();
      }
    );
  }
}