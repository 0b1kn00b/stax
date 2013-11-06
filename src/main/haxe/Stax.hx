import Type;

import Prelude;

import hx.sch.*;
import hx.ifs.Scheduler;

import haxe.PosInfos;

import stx.Chunk;
import stx.plus.Meta;
import stx.Method;
import stx.Types;
import stx.Fail;
import stx.Option;
import stx.Compare;

import stx.ioc.Inject.*;
import stx.log.Logger;
import stx.log.DefaultLogger;

@doc("
  The opinionated class, brings in a bunch of global scope stuff I find useful.
")
class Stax{
  @:bug('#0b1kn00b: making __init__ causes BASE64 in Unserializer to be null @25/10/2013')
  public static function init(){
    var injector = injector();
    injector.bind(Logger,new DefaultLogger());
    haxe.Log.trace = inject(Logger).apply;
    #if(js || flash)
      injector.bind(Scheduler,new EventScheduler());
    #elseif neko
      injector.bind(Scheduler,new ThreadScheduler());
    #else 
      injector.bind(Scheduler,new InlineScheduler());
    #end
  }
  @:noUsing static public inline function option<T>(?v:Null<T>):Option<T>{
    return Options.create(v);
  }
  @:noUsing static public inline function chunk<T>(?v:Null<T>):Chunk<T>{
    return Chunks.create(v);
  }
  @:noUsing static public inline function fail(cde:EnumValue,?pos:PosInfos):Fail{
    return Fail.fail(cde,pos);
  }
  @:noUsing static public inline function except<T>(?pos:haxe.PosInfos):Error -> T{
    return function(err:Error):T{
      throw(fail(err,pos));
      return null;
    }
  }
  @:noUsing static public inline function compare<T>(v:T){
    return new Predicator(v);
  }
  @:noUsing static public inline function thunk<T>(v:T):Void->T{
    return stx.Anys.toThunk(v);
  }
  @:noUsing static public inline function assert<T>(v:T,?str:String,?prd:Predicate<T>,?er:Fail,?pos:PosInfos){
    return stx.Assert.assert(v,str,prd,er,pos);
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
  @:noUsing static public var noop    = function(){}
  /*@:noUsing static public inline function metadata<T>(v:T):MetaObjectContainer{
    return stx.plus.Meta.metadata(v);
  }*/
}