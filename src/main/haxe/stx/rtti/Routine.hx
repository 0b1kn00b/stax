package stx.rtti;

import haxe.rtti.CType;

import stx.Prelude;
import stx.Fail;
import stx.Fail.*;

using stx.Compose;
using stx.Eithers;
using stx.Iterables;
using stx.Options;
using stx.rtti.RTypes;
using stx.Tuples;
using stx.Reflects;

/**
  Wrapper for reflected functions.
*/
abstract Routine<T>(Tuple2<T,String>) from Tuple2<T,String>{
  public function new(v){
    this = v;
  }
  public function apply(?args:Array<Dynamic>):Dynamic{
    return Reflects.callFunction(this.fst(),this.snd(),args);
  }
  public function applySafe(?args:Array<Dynamic>):Option<Dynamic>{
    return Reflects.callSafe(this.fst(),Reflect.field(this.fst(),this.snd()),args);
  }
  public function applySecure(?args:Array<Dynamic>):Outcome<Dynamic>{
    return Reflects.callSecure(this.fst(),this.snd(),args);
  }
}