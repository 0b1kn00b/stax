package stx.fnc.mnd;

import Prelude.Outcome in OutcomeType;

import Stax.*;

import Prelude.Outcome;
import stx.Tuples;
import stx.Either;
import stx.fnc.Outcome in AOutcome;

using stx.Option;

class Outcome<T> extends Base<OutcomeType<T>,T>{
  public function new(outcome:OutcomeType<T>){
    super(outcome);
  }
  inline override public function pure<U>(v:U){
    return new Outcome(Success(v));
  }
  @:note('#0b1kn00b: Boxing / unboxing may have to get complicated while abstract types firm up')
  inline override public function flatMap<U>(fn:T->Monad<U>,?self:Outcome<T>):Monad<U>{
    self = self == null ? this : self;
    var oc : OutcomeType<T> = self.box().unbox();
    return switch (oc) {
      case Success(success) : fn(success);
      case Failure(failure) : box().box(Failure(failure));
    }
  }
  override inline public function map<U>(fn:T->U,?self:Outcome<T>):Monad<U>{
    self = self == null ? this : self;
    var oc : OutcomeType<T> = self.box().unbox();
    return switch (oc) {
      case Success(v) : Success(fn(v));
      case Failure(e) : Failure(e);
    }
  }
}