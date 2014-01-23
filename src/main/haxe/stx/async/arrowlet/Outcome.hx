package stx.async.arrowlet;

import Prelude;
import Stax.*;
import stx.Fail;
import stx.Compare.*;

import stx.Outcome;
import stx.Tuples;
import stx.Either;

using stx.async.Arrowlet;

typedef ArrowletOutcome<I,O> = Arrowlet<Prelude.Outcome<I>,Prelude.Outcome<O>>

abstract Outcome<I,O>(ArrowletOutcome<I,O>) from ArrowletOutcome<I,O> to ArrowletOutcome<I,O>{
  static public function outcome<I,O>(?v:ArrowletOutcome<I,O>):Outcome<I,O>{
    return new Outcome(v);
  }
  static public function unit<I,O>():Outcome<I,O>{
    return new Outcome();
  }
  public function new(?v:ArrowletOutcome<I,O>){
    this = ntnl().apply(v) ? v : 
    function(x){
        return cast( x == null ? Failure(fail(NullReferenceError('unknown'))) : x);
    } 
  }
}
class Outcomes{
  static public function attempt<I,O,N>(arw0:ArrowletOutcome<I,O>,arw1:Arrowlet<O,Prelude.Outcome<N>>):Outcome<I,N>{
    return arw0.then(arw1.fromRight());
  }
  static public function edit<I,O,N>(arw0:ArrowletOutcome<I,O>,arw1:Arrowlet<O,N>):Outcome<I,N>{
    return arw0.then(arw1.right());
  }
  static public function split<I,O,N>(arw0:ArrowletOutcome<I,O>,arw1:Outcome<I,N>):Outcome<I,Tuple2<O,N>>{
    return arw0.split(arw1).then(Eithers.unzip);
  }
  static public function imply<I,O>(arw0:ArrowletOutcome<I,O>,v:I){
    return arw0.apply(Right(v));
  }
}