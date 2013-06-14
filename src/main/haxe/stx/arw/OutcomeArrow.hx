package stx.arw;

import stx.Tuples;
import stx.Error.*;
import stx.Eithers;
import stx.Prelude;
using stx.arw.Arrows;

typedef ArrowOutcome<I,O> = Arrow<Outcome<I>,Outcome<O>>

abstract OutcomeArrow<I,O>(ArrowOutcome<I,O>) from ArrowOutcome<I,O> to ArrowOutcome<I,O>{
  static public function outcome<I,O>(?v:ArrowOutcome<I,O>):OutcomeArrow<I,O>{
    return new OutcomeArrow(v);
  }
  static public function unit<I,O>():OutcomeArrow<I,O>{
    return new OutcomeArrow();
  }
  public function new(?v:ArrowOutcome<I,O>){
    this = Options.orDefault(v,
      function(x){
        return cast( x == null ? Left(err('null input')) : x);
      }
    );
  }
}
class OutcomeArrows{
  static public function attempt<I,O,N>(arw0:ArrowOutcome<I,O>,arw1:Arrow<O,Outcome<N>>):OutcomeArrow<I,N>{
    return arw0.then(arw1.fromR());
  }
  static public function edit<I,O,N>(arw0:ArrowOutcome<I,O>,arw1:Arrow<O,N>):OutcomeArrow<I,N>{
    return arw0.then(arw1.right());
  }
  static public function split<I,O,N>(arw0:ArrowOutcome<I,O>,arw1:OutcomeArrow<I,N>):OutcomeArrow<I,Tup2<O,N>>{
    return arw0.split(arw1).then(Eithers.unzip);
  }
  static public function imply<I,O>(arw0:ArrowOutcome<I,O>,v:I){
    return arw0.apply(Right(v));
  }
}