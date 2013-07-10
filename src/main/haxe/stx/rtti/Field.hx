package stx.rtti;

import haxe.rtti.CType;

import stx.Prelude;
import stx.Error;
import stx.Error.*;

using stx.Compose;
using stx.Eithers;
using stx.Iterables;
using stx.Options;
using stx.Tuples;
using stx.Reflects;


abstract Field<T>(Tuple2<T,String>) from Tuple2<T,String>{
  public function new(v){
    this = v;
  }
  public function value():Option<Dynamic>{
    return Options.create(Reflect.field(this.fst(),this.snd()));
  }
}