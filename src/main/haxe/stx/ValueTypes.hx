package stx;

import Type;

using stx.Arrays;
@doc("
  ```
  using Type;
  using ValueTypes;
  
  class Test(){
    static function main(){
      v.typeof().name();
    }
  }
  ```
")
class ValueTypes{
  @doc("Returns the local Class name of a `ValueType`.")
  @params("A typed object","The objects typename")
  @:thx inline public static function leaf(v : ValueType):String{
    return name(v).split('.').pop();
  }
  @doc("Returns the type name of any `ValueType`.")
  @:thx public static function name(v : ValueType):String{
    return switch(v){
      case TNull    : "null";
      case TInt     : "Int";
      case TFloat   : "Float";
      case TBool    : "Bool";
      case TFunction: "function";
      case TClass(c): Type.getClassName(c);
      case TEnum(e) : Type.getEnumName(e);
      case TObject  : "Object";
      case TUnknown : "Unknown";
    }
  }
  static public function pack(v : ValueType):String{
    return switch (v) {
      case TNull, TInt, TFloat, TBool, TFunction, TObject, TUnknown : 'std';
      case TClass(c)  : Type.getClassName(c).split('.').dropRight(1).join('.');
      case TEnum(c)   : Type.getEnumName(c).split('.').dropRight(1).join('.');
    }
  }
  @doc("Resolves typename to `ValueType`.")
  static public inline function resolve(str:String):ValueType{
    var o = TUnknown;
    try{
      o = Type.typeof(Type.resolveClass(str));
    }catch(e:Dynamic){
      try{
        o = Type.typeof(Type.resolveEnum(str));
      }catch(e:Dynamic){

      }
    }
    return o;
  }
}