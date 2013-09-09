import Type;

import stx.Prelude;

import haxe.PosInfos;

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
  @:noUsing static public inline function type<T>(v:Dynamic):ValueType{
    return Types.type(v);
  }
}