package stx;

using stx.Prelude;
using stx.Arrays;

import stx.Objects;
import stx.Prelude;

using stx.Tuples;
using stx.Eithers;
using stx.Maybes;
using stx.Functions;
using stx.Error;
using stx.Compose;
using stx.Types;

class Types{
  /**
    Safe resolveClass
  */
  static public function resolveClassO(s:String):Maybe<Class<Dynamic>>{
    return Maybes.create(Type.resolveClass(s));
  }
  static public function getClassO<A>(c:A):Maybe<Class<A>>{
    return Maybes.create(Type.getClass(c));
  }
  static public function extractClassNameO(v:Dynamic):Maybe<String>{
    return Types.getClassO(v).map( Type.getClassName );
  }
  static public function getClassHierarchy<A>(type:Class<A>):Array<Class<Dynamic>>{
    var o = [];
    var t : Class<Dynamic> = type;
    while(t!=null){
      o.push(t);
      t = Type.getSuperClass(t);
    }
    return o;
  }
  @:note('#0b1kn00b: depends upon `until` actually being part of the hierarchy')
  @:unsafe
  static public function getClassHierarchyUntil<A>(type:Class<A>,until:Class<Dynamic>):Array<Class<Dynamic>>{
    return 
      getClassHierarchy(type).takeWhile(
        function(x){
          return Type.getClassName(x) != Type.getClassName(until);
        }
      ).add(until);
  }
  static public function getSuperClassO(type:Class<Dynamic>):Maybe<Class<Dynamic>>{
    return Maybes.create(Type.getSuperClass(type));
  }
  static public function createInstanceE<A>(type:Class<A>,?args:Array<Dynamic>):Either<Error,A>{
    args = if(args == null) [] else args;
    return 
      Type.createInstance.lazy(type,args).catching()();
  }
  static public function resolveCreate<A>(name:String,?args:Array<Dynamic>):Outcome<A>{
    return Types.resolveClassO.first().pinch().then(
      function(l:Maybe<Class<Dynamic>>,r:String){
        return switch (l){
          case Some(v)      : Right(v);
          default           : Left(stx.Error.create('Type "$r" not found.'));
        }
      }.spread()
    )(name).flatMapR(Types.createInstanceE.p2(args == null ? [] : args));
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
   static public function extractAllAnyFromType<A>(v:A):Maybe<Array<Tuple2<String,Dynamic>>>{
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