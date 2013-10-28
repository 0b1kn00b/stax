package stx.rtti;

import Stax.*;
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

@doc("
  A Tuple of the underlying type and an Array of field names.
")
abstract Reflection<T>(Tuple2<T,Array<String>>) from Tuple2<T,Array<String>>{
  public function new(v){
    this = v;
  }
  @doc("Returns the value of field `key`.")
  public function get(key:String):Option<Dynamic>{
    return this.snd().search(function(x) return x == key)
      .flatMap(
        Reflects.getValue.bind(this.fst()).then(option)
      );
  }
  @doc("Calls function key with args with no error handling")
  public function call(key:String,?args:Array<Dynamic>):Dynamic{
    return Reflects.callFunction(this.fst(),key,args);
  }
  @doc("@see `Reflects.callSafe`")
  public function callSafe(key:String,?args:Array<Dynamic>):Option<Dynamic>{
    return Reflects.callSafe(this.fst(),key,args);
  }
  @doc("@see `Reflects.callSecure`")
  public function callSecure(key:String,?args:Array<Dynamic>):Outcome<Dynamic>{
    return Reflects.callSecure(this.fst(),key,args);
  }
  @doc("Produces an Array of non function fields.")
  @:note('Inconsistency with Reflect')
  public function fields():Array<Field<T>>{
    return this.snd()
    .filter(
      function(x){
        return !Reflect.isFunction(Reflect.field(this.fst(),x));
      }
    ).map(
      function(x){
        return new Field(tuple2(this.fst(),x));
      }
    );
  }
  @doc("Produces the Routines of T.")
  public function routines():Array<Routine<T>>{
    return this.snd()
    .filter(
      function(x){
        return Reflect.isFunction(Reflect.field(this.fst(),x));
      }
    ).map(
      function(x){
        return new Routine(tuple2(this.fst(),x));
      }
    ); 
  }
  @doc("Returns the source value.")
  public function object():Dynamic{
    return this.fst();
  }
}