package stx;

using stx.Prelude;
using stx.Arrays;

import stx.Error.*;
import stx.Errors;

import stx.Objects;
import stx.Prelude;

using stx.Tuples;
using stx.Eithers;
using stx.Options;
using stx.Functions;
using stx.Error;
using stx.Compose;
using stx.Types;

class Types{
  static public function resolve(name:String):Class<Dynamic>{
    return Type.resolveClass(name);
  }
  static public function resolveClassOption<T>(s:String):Option<Class<T>>{
    return Options.create(cast Type.resolveClass(s));
  }
  static public function resolveClassEither<T>(s:String):Outcome<Class<T>>{
    return resolveClassOption(s).orEitherC(err(NullReferenceError('$s')));
  }
  static public function getClassOption<A>(c:A):Option<Class<A>>{
    return Options.create(Type.getClass(c));
  }
  static public function extractClassNameOption(v:Dynamic):Option<String>{
    return Types.getClassOption(v).map( Type.getClassName );
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
  static public function getSuperClassOption(type:Class<Dynamic>):Option<Class<Dynamic>>{
    return Options.create(Type.getSuperClass(type));
  }
  static public function createInstanceEither<A>(type:Class<A>,?args:Array<Dynamic>):Either<Error,A>{
    args = if(args == null) [] else args;
    var v : A = null;
    try{
      v = Type.createInstance(type,args);  
    }catch(e:Dynamic){
      return Left(err(NativeError(Std.string(e))));
    }
    return Right(v);
  }
  static public function createInstanceOption<A>(type:Class<A>,?args:Array<Dynamic>):Option<A>{
    args = if(args == null) [] else args;
    return try{
      Some(Type.createInstance(type,args));  
    }catch(e:Dynamic){
      None;
    }
  }
  static public function resolveCreateOutcome<A>(name:String,?args:Array<Dynamic>):Outcome<A>{
    return Types.resolveClassOption.first().pinch().then(
      function(l:Option<Class<Dynamic>>,r:String){
        return switch (l){
          case Some(v)      : Right(v);
          default           : Left(err(NullReferenceError('Type "$r"')));
        }
      }.spread()
    )(name).flatMapR(Types.createInstanceEither.p2(args == null ? [] : args));
  }
  /**
    Does ´type´ exist in the Class hierarchy?
    @param  type
    @param  sup
  */
  @:thx
  static public inline function hasSuperClass(type : Class<Dynamic>, sup : Class<Dynamic>):Bool{
    var o = false;
    while(null != type)
    {
      if(type == sup){
        o = true;
        break;
      }
      type = Type.getSuperClass(type);
    }
    return o;
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
   static public inline function ofOutcome<T>(type:Class<T>, value: Dynamic):Outcome<T>{
     return try{
       Right(of(type,value));
     }catch(e:Dynamic){
        Left(err(NativeError(e)));
     }
   }
   static public function extractAllAnyFromTypeOption<A>(v:A):Option<Array<Tuple2<String,Dynamic>>>{
    return
      Types.getClassOption(v)
        .map(
          function(x){
            var a = Type.getInstanceFields(x);
            return a.zip(a.map(Reflect.field.p1(v)));
          }
        );
   }

   //static public function extractFieldsFromType<A>(v:A)
  /**
   Returns the local Class name of an object.
   @param o       A typed object.
   @return        The objects typename.
 */
 @:thx inline public static function className(o : Dynamic):String{
    return fullName(o).split('.').pop();
  }

  /**
    Gets the full Class name of a Class instance.
    @param o
   */
  @:thx inline public static function fullName(o : Dynamic){
    return Type.getClassName(Type.getClass(o));
  }
  /**
    Returns the type name of any object using Type.typeof()
    @param o
    @return
   */
  @:thx public static function typeName(o : Dynamic):String{
    return switch(Type.typeof(o)){
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
  static public function pack(o:Dynamic):String{
    return switch (Type.typeof(o)) {
      case TNull, TInt, TFloat, TBool, TFunction, TObject, TUnknown : 'std';
      case TClass(c)  : Type.getClassName(c).split('.').dropRight(1).join('.');
      case TEnum(c)   : Type.getEnumName(c).split('.').dropRight(1).join('.');
    }
  }
}