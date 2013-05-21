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
  public function attempt<N>(arw:Arrow<O,Outcome<N>>):OutcomeArrow<I,N>{
    return this.then(arw.fromR());
  }
  public function edit<N>(arw:Arrow<O,N>):OutcomeArrow<I,N>{
    return this.then(arw.right());
  }
  public function split<N>(arw:OutcomeArrow<I,N>):OutcomeArrow<I,Tup2<O,N>>{
    return this.split(arw).then(Eithers.unzip);
  }
  public function imply(v:I){
    return this.apply(Right(v));
  }
}