package stx.rtti;

import Prelude;
import haxe.rtti.CType;

import stx.Fail;
import stx.Fail.*;

using stx.Arrays;
using stx.Compose;
using stx.Either;
using stx.Iterables;
using stx.Option;
using stx.rtti.RTypes;
using stx.Tuples;
using stx.Reflects;

@doc("
  A binding of a source object and it's rtti.
")
abstract RClass<T>(Tuple2<T,Classdef>) from Tuple2<T,Classdef> to Tuple2<T,Classdef>{
  public function new(v){
    this = v;
  }
  public function reflection(?fn:ClassField->Bool):Reflection<T>{
    fn = fn == null ? function(x) {return true;} : fn; 
    return tuple2(this.fst(),
      this.snd().fields.filter(fn).toArray().map(function(x) return x.name)
    );
  }
  @doc("Recursive returns flattened list of fields from the type hierarchy compared by name to avoid duplicates.")
  @:todo('#0b1kn00b: make sure duplicates are the most recent in hierarchy.')
  public function reflector(?recursive:Bool):Reflector<T,Dynamic>{
    return tuple2(this.fst(),
      recursive ? {
        var all = Classdefs.ancestors(this.snd()).val()
        .map(function(x) return x.fields.toArray())
        .flatMap(Compose.unit());

        var next : Array<ClassField>= [];
        all.each(
          function(x:ClassField){
            if (!next.any(function(y) return x.name == y.name)) {
              next.push(x);
            }
          }
        );
        next.map(
          function(x){
            return tuple2(x,Reflect.field(this.fst(),x.name));
          }  
        );}
      : this.snd().fields.toArray().map(
        function(x){
          return tuple2(x,Reflect.field(this.fst(),x.name));
        }
      )
    );
  }
  public function constructor(){
    return this.snd().fields.search(
      function(x){
        return x.name == 'new';
      }
    ).val();
  }
  public function fields(?recursive):Array<ClassField>{
    var all = Classdefs.ancestors(this.snd()).val()
        .map(function(x) return x.fields.toArray())
        .flatMap(Compose.unit());

        var next : Array<ClassField>= [];
        all.each(
          function(x:ClassField){
            if (!next.any(function(y) return x.name == y.name)) {
              next.push(x);
            }
          }
        );
    return next;
  }
}