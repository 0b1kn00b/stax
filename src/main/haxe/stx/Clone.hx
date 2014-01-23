package stx;

import Type;
import stx.ds.Set;
import Stax.*;
import haxe.ds.IntMap;

import stx.Hasher;

using stx.Iterables;
using stx.Enums;
using stx.Compare;
using stx.Arrays;
using stx.Compose;
using stx.Tuples;

typedef CloneFunction<T> = T -> Array<Dynamic> -> T;

class Clone{
  static public function getCloneFor<T>(v:T):CloneFunction<T>{
    return getCloneForType(Type.typeof(v));
  }
  static public function getCloneForType<T>(v:ValueType):CloneFunction<T>{
    return switch(v) {
      case TInt,TFloat,TBool,TNull,TFunction  : clone_immutable;
      case TClass(c) if(c == String)          : clone_immutable;
      case TClass(c) if(c == Date)            : __clone__(cast DateClone.clone);
      case TClass(c)                          : __clone__(UnsupportedClassClone.clone);
      case TEnum(e)                           : __clone__(cast EnumClone.clone);
      case TObject                            : __clone__(ObjectClone.clone);
      case TUnknown                           : __clone__(clone_immutable); //?not sure about this
    }
  }
  static private function clone_immutable<T>(v:T,stack:Array<Dynamic>){
    return v;
  }
  static private function __clone__<T>(impl:CloneFunction<T>):CloneFunction<T>{
    return function(v:T,stack:Array<Dynamic>):T{
      if(stack.remove(v)){
        stack.push(v);
        return v;
      }else{
        stack.push(v);
      }
      return impl(v,stack);
    }
  }
}
@:note('#0b1kn00b: if there are lambdas as instance vars they will not be copied as there is no way to differentiate them without errors')
@:note("OK, I lied, but you'll need to try to copy all functions and catch errors")
class UnsupportedClassClone{
  @:noUsing static public function clone<T>(v:T,stack:Array<Dynamic>):T{
    var tp   = Type.getClass(v);
    var nw   = Type.createEmptyInstance(tp);
    var keys = Set.create();
        keys = keys.append(Reflect.fields(v));

    switch (vtype(v)) {
      case TClass(c) : keys = keys.append(Type.getInstanceFields(c));
      default       :
    }
    var flds = 
      keys.toArray()
        .zip(keys.toArray()).map(Reflect.field.bind(v).second())
        .filter(Tuples2.snd.then(Reflect.isFunction.not().apply))
        .map(
          function(x){
            return Clone.getCloneFor(x)(x,stack);
          }.second()
        );
    flds.each(Reflect.setField.bind(nw).tupled());
    return nw;
  }
}
class EnumClone{
  @:noUsing static public function clone(v:EnumValue,stack:Array<Dynamic>):EnumValue{
    var nw      = v.toEnum();
    var nm      = v.constructor();
    var params  = v.params().map(
      function(x){
        return Clone.getCloneFor(x)(x,stack);
      }
    );
    return Enums.create(nw,nm,params);
  }
}
class ObjectClone{
  @:noUsing static public function clone<T>(v:T,stack:Array<Dynamic>):T{
    var nw : Dynamic  = {};
    var keys          = Reflect.fields(v);
    var flds          = 
      keys.zip(keys).map(Reflect.field.bind(v).second())
        .map(
          function(x){
            return Clone.getCloneFor(x)(x,stack);
          }.second()
        );
    flds.each(Reflect.setField.bind(nw).tupled());
    return nw;
  }
}
class DateClone{
  @:noUsing static public function clone(v:Date,stack:Array<Dynamic>):Date{
    return Date.fromTime(v.getTime());
  }
}