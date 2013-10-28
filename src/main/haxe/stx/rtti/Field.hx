package stx.rtti;

import haxe.rtti.CType;

import stx.Prelude;
import stx.Fail;
import stx.Fail.*;

using stx.Compose;
using stx.Either;
using stx.Iterables;
using stx.Option;
using stx.Tuples;
using stx.Reflects;

abstract Field<T>(Tuple2<T,String>) from Tuple2<T,String>{
  public function new(v){
    this = v;
  }
  public var value(get,never) : Dynamic;
  private function get_value() : Dynamic{
    return Reflect.field(this.fst(),this.snd());
  }
}