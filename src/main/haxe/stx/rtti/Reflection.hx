package stx.rtti;

import haxe.rtti.CType;

import stx.Prelude;
import stx.Error;
import stx.Error.*;

using stx.Compose;
using stx.Eithers;
using stx.Iterables;
using stx.Options;
using stx.rtti.RTypes;
using stx.Tuples;
using stx.Reflects;

abstract Reflection<T>(Tuple2<T,Array<String>>) from Tuple2<T,Array<String>>{
  public function new(v){
    this = v;
  }
  public function get(key:String):Option<Dynamic>{
    return this.snd().find(function(x) return x == key)
      .flatMap(
        Reflects.getFieldOption.bind(this.fst())
      );
  }
  public function call(key:String,?args:Array<Dynamic>):Dynamic{
    return Reflects.callFunction(this.fst(),key,args);
  }
  public function callSafe(key:String,?args:Array<Dynamic>):Option<Dynamic>{
    return Reflects.callSafe(this.fst(),key,args);
  }
  public function callSecure(key:String,?args:Array<Dynamic>):Outcome<Dynamic>{
    return Reflects.callSecure(this.fst(),key,args);
  }
  public function fields():Array<Field<T>>{
    return this.snd()
    .filter(
      function(x){
        return !Reflect.isFunction(Reflect.field(this.fst(),x));
      }
    ).map(
      function(x){
        return tuple2(this.fst(),x);
      }
    );
  }
  public function routines():Array<Routine<T>>{
    return this.snd()
    .filter(
      function(x){
        return Reflect.isFunction(Reflect.field(this.fst(),x));
      }
    ).map(
      function(x){
        return tuple2(this.fst(),x);
      }
    ); 
  }
  public function object():Dynamic{
    return this.fst();
  }
}