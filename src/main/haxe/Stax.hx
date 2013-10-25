import Type;

import stx.Prelude;

import haxe.PosInfos;

import stx.plus.Meta;
import stx.Method;
import stx.Types;
import stx.Fail;
import stx.Options;
import stx.Compare;

class Stax{
  @:noUsing static public inline function option<T>(v:Null<T>):Option<T>{
    return Options.create(v);
  }
  @:noUsing static public inline function fail(cde:EnumValue):Fail{
    return Fail.fail(cde);
  }
  @:noUsing static public inline function except<T>(?pos:haxe.PosInfos):Fail -> T{
    return function(err:Fail):T{
      throw(err);
      return null;
    }
  }
  @:noUsing static public inline function compare<T>(v:T){
    return new Predicator(v);
  }
  @:noUsing static public inline function thunk<T>(v:T):Void->T{
    return stx.Anys.toThunk(v);
  }
  @:noUsing static public inline function assert<T>(prd:Predicate<T>,?v:T,?er:Fail,?pos:PosInfos){
    return stx.Assert.assert(prd,v,er,pos);
  }
  @:noUsing static public inline function vtype<T>(v:Dynamic):ValueType{
    return Types.vtype(v);
  }
  @:noUsing static public inline function method1<A,B>(fn:A->B):Method<A,B>{
    return new Method(fn);
  }
  @:noUsing static public inline function here(?p:PosInfos):PosInfos{
    return p;
  }
  @:noUsing static public inline function printer(?p:PosInfos){
    return stx.Log.printer(p);
  }
  /*@:noUsing static public inline function metadata<T>(v:T):MetaObjectContainer{
    return stx.plus.Meta.metadata(v);
  }*/
}