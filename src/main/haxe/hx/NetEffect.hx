package hx;

import Prelude;

import hx.ifs.NetEffect in INetEffect;

abstract NetEffect(INetEffect) from INetEffect to INetEffect{
  public function new(v){
    this = v;
  }
  public function invoke(){
    return this.invoke();
  }
}