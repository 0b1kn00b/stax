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
  Binding of a value and it's TypeTree.
*/
abstract RType<T>(Tuple2<T,TypeTree>) from Tuple2<T,TypeTree> to Tuple2<T,TypeTree>{
  public function new(v){
    this = v;
  }
/*  @:from public static inline function fromClass<T:{function new():Void;}>(cls:Class<T>):RType<T>{
    var val = Type.createInstance(cls,[]);
    return tuple2(val,RTypes.typetree(cls).get());
  }*/
  public function native(){
    return this;
  }
  public function getClass():Option<RClass<T>>{
    return (switch(this.snd()){
      case TClassdecl(c)  : Some(c);
      default             : None;
    }).map(tuple2.bind(this.fst()));
  }
}