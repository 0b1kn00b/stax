package stx;

import stx.Prelude;

abstract Niladic(NiladicType) from NiladicType to NiladicType{
  @:noUsing static public inline function unit(){
    return function(){}
  }
  public function new(v){
    this = v;
  }
  public function run(){
    (this());
  }  
}