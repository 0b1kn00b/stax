package stx;

using stx.Prelude;
using stx.Arrays;

import stx.Tuples;
import stx.Prelude;

using stx.Options;
using stx.Functions;
using stx.Error;

class Types{
  /**
    Safe resolveClass
  */
  static public function resolveClass(s:String):Option<Class<Dynamic>>{
    return Options.create(Type.resolveClass(s));
  }
  static public function getSuperClass(type:Class<Dynamic>):Option<Class<Dynamic>>{
    return Options.create(Type.getSuperClass(type));
  }
  static public function createInstance<A>(type:Class<A>,args:Array<Dynamic>):Either<Error,A>{
    return 
      Type.createInstance.lazy(type,args).catching()();
  }

  /**
    Does ´type´ exist in the Class hierarchy?
    @param  type
    @param  sup
  */
  @:thx
  public static function hasSuperClass(type : Class<Dynamic>, sup : Class<Dynamic>):Bool
  {
    while(null != type)
    {
      if(type == sup)
        return true;
      type = Type.getSuperClass(type);
    }
    return false;
  }
  /**
    @param type      A Type to cast to.
    @param value     A value to cast.
    @return          The casted value.
   */
   @:thx
   static public inline function of<T>(type : Class<T>, value : Dynamic) : Null<T>{
      return (Std.is(value, type) ? cast value : null);
   }

   static public function extractAllAny<A>(v:A):Array<Tuple2<String,Dynamic>>{
      var flds = Type.getInstanceFields(Type.getClass(v));
      return 
        flds.zip(flds.map(Reflect.field.p1(v)));
   }
}