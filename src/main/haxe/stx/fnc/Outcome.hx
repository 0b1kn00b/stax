package stx.fnc;

import Prelude.Outcome in EOutcome;

import stx.fnc.mnd.Outcome in COutcome;

abstract Outcome<T>(COutcome<T>) from COutcome<T> to COutcome<T>{
  public function new(v){
    this = v;
  }
  @:static public function fromType<T>(oc:EOutcome<T>){
  	return new COutcome(oc);
  }
}