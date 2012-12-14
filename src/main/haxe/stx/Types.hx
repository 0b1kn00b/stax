package stx;

using stx.Prelude;
using stx.Arrays;

import stx.Objects;
import stx.Tuples;
import stx.Prelude;

using stx.Options;
using stx.Functions;
using stx.Error;
using stx.Compose;
using stx.Types;

class Types{
  /**
    Safe resolveClass
  */
  static public function resolveClassO(s:String):Option<Class<Dynamic>>{
    return Options.create(Type.resolveClass(s));
  }
  static public function getClassO<A>(c:A):Option<Class<A>>{
    return Options.create(Type.getClass(c));
  }
  static public function extractClassNameO(v:Dynamic):Option<String>{
    return Types.getClassO(v).map( Type.getClassName );
  }
  static public function getSuperClassO(type:Class<Dynamic>):Option<Class<Dynamic>>{
    return Options.create(Type.getSuperClass(type));
  }
  static public function createInstance<A>(type:Class<A>,?args:Array<Dynamic>):Either<Error,A>{
    args = if(args == null) [] else args;
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
   static public function extractAllAnyFromType<A>(v:A):Option<Array<Tuple2<String,Dynamic>>>{
    return
      Types.getClassO(v)
        .map(
          function(x){
            var a = Type.getInstanceFields(x);
            return a.zip(a.map(Reflect.field.p1(v)));
          }
        );
   }
   static public function extractObjectFromType<A>(v:A):Object{
      return extractAllAnyFromType(v).map(Objects.toObject).getOrElse(Objects.create);
   }

   //static public function extractFieldsFromType<A>(v:A)
  /**
   Returns the local Class name of an object.
   @param o       A typed object.
   @return        The objects typename.
 */
 @:thx
  inline public static function className(o : Dynamic):String
  {
    return fullName(o).split('.').pop();
  }

  /**
    Gets the full Class name of a Class instance.
    @param o
   */
  @:thx
  inline public static function fullName(o : Dynamic)
  {
    return Type.getClassName(Type.getClass(o));
  }
  /**
    Returns the type name of any object using Type.typeof()
    @param o
    @return
   */
  @:thx
  public static function typeName(o : Dynamic) : String
  {
    return switch(Type.typeof(o))
    {
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
}