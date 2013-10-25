package stx;

using Type;

import Stax.*;

using stx.ValueTypes;
using stx.Prelude;
using stx.Arrays;

import stx.Fail.*;
 

import stx.Objects;
import stx.Prelude;

using stx.Tuples;
using stx.Eithers;
using stx.Options;
using stx.Functions;
using stx.Fail;
using stx.Compose;
using stx.Types;

class Types{

  static public inline function type(v:Dynamic):Class<Dynamic>{
    return Type.getClass(v);
  }
  /**
    returns ValueType
  */
  static public inline function vtype(v:Dynamic):ValueType{
    return Type.typeof(v);
  }
  /**
    Returns Class of `name`
  */
  static public function classify(name:String):Class<Dynamic>{
    return cast Type.resolveClass(name);
  }
  @:note('#0b1kn00b: depends upon `until` actually being part of the hierarchy')
  @:unsafe
  static public function ancestors<A>(type:Class<A>,?until:Class<Dynamic>):Array<Class<Dynamic>>{
    var o = [];
    var t : Class<Dynamic> = type;
    while(t!=null){
      o.push(t);
      t = Type.getSuperClass(t);
    }
    if(until!=null){
      o = o.takeWhile(
        function(x){
          return x.typeof().name() != until.typeof().name();
        }
      ).add(until);
    }
    return o;
  }
  /**
    class name
  */
  static public function name<A>(cls:Class<A>):String{
    return Type.getClassName(cls);
  }
  /**
    package name
  */
  static public function pack(cls:Class<Dynamic>):String{
    var o = name(cls).split('.');
        o.pop();
    return o.join('.');
  }
  /*
    Construct `type` with optional args
  */
  static public function construct<A>(type:Class<A>,?args:Array<Dynamic>):Null<A>{
    args = args == null ? [] : args;

    return try{
      Type.createInstance(type,args);  
    }catch(e:Fail){
      throw(e);
    }catch(e:Dynamic){
      throw(fail(ConstructorFail(type,fail(NativeFail(e)))));
    }
  }
  /**
  */
  @:note('#0b1kn00b: could generalise this for enums')
  static public function build<A>(name:String,?args:Array<Dynamic>):A{
    return option(classify(name)).flatMap(
      construct.bind(_,args).then(option)
    ).getOrElse(thunk(null));
  }
  /**
    Create type, bypassing constructor
  */
  static public inline function instantiate<A>(type:Class<A>):A{
    return Type.createEmptyInstance(type);
  }
  /**
    Fieldnames for instance variables
  */
  static public inline function locals<A>(type:Class<A>):Array<String>{
    return Type.getInstanceFields(type);
  }
  /**
    Fieldnames for class statics
  */
  static public inline function statics<A>(type:Class<A>):Array<String>{
    return Type.getClassFields(type);
  }
  /**
    Does `type` exist in the Class hierarchy?
    @param  type
    @param  sup
  */
  @:thx
  static public inline function descended(type : Class<Dynamic>, sup : Class<Dynamic>):Bool{
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
      return try{
        (Std.is(value, type) ? cast value : null);
      }catch(e:Dynamic){
        throw fail(TypeFail('could not cast value to ${name(type)}'));
      }
  }
  /**
    Do the fields of `obj` fit into the schema of `type`. 
    Specifically, are the fields in `obj` a match or subset of the fields found in `type`.
    This is still no guarantee that they are compatible because the field types may not match.
  */
  /*static public function fits(type:Class<T>,obj:Dynamic):Bool{

  }*/
  /**
    Do the fields
  */
}