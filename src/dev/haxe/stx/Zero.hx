package stx;

import stx.ifs.Zero in IZero;

abstract Zero<T>(IZero<T>) from IZero<T> to IZero<T>{
  public function new(v){
    this = v;
  }
}