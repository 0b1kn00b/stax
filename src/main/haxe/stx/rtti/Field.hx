package stx.rtti;

import Prelude;

using stx.Tuples;

abstract Field<T>(Tuple2<String,T>) from Tuple2<String,T> to Tuple2<String,T>{
  public function new(v){
    this = v;
  }
  public var key(get,never):Dynamic;
  private inline function get_key() : Dynamic{
    return this.fst();
  }
  public var val(get,never) : Dynamic;
  private inline function get_val() : Dynamic{
    return this.snd();
  }
}