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
  public function append(n2:Niladic):Niladic{
    return function(){
      run(this);
      n2.run();
    };
  }
}