package stx.rtti;

import Prelude;

using stx.Tuples;

abstract Field<T>(Tuple2<String,T>) from Tuple2<String,T> to Tuple2<String,T>{
  public function new(v){
    this = v;
  }
  public var key(get,never):String;
  private inline function get_key() : String{
    return this.fst();
  }
  public var val(get,never) : Dynamic;
  private inline function get_val() : Dynamic{
    return this.snd();
  }
  public function isFunction():Bool{
    return Fields.isFunction(this);
  }
}
class Fields{
  static public function isFunction<T>(fld:Field<T>):Bool{
    return Reflect.isFunction(fld.val());
  }
}