import Type;

import Prelude;

import hx.scheduler.*;
import hx.ifs.Scheduler;
import stx.io.Log.*;

import haxe.PosInfos;

import stx.async.Arrowlet;
import stx.Chunk;
import stx.Meta;
import stx.Method;
import stx.Types;
import stx.Fail;
import stx.async.Promise;
import stx.async.Future;
import stx.Option;
import stx.Compare;

import stx.ioc.Inject.*;
import stx.io.log.Logger;
import stx.io.log.DefaultLogger;

using stx.Tuples;

@doc("The opinionated class, brings in a bunch of global scope stuff I find useful.")
class Stax{
  @:bug('#0b1kn00b: making __init__ causes BASE64 in Unserializer to be null @25/10/2013')
  public static function init(){
    var injector = injector();
    if(!injector.bound(Logger,here())){
      injector.bind(Logger,new DefaultLogger());
    }
    //haxe.Log.trace = inject(Logger).apply;
    #if(js || flash)
      //log(info('EventScheduler'));
      injector.bind(Scheduler,new EventScheduler());
    #elseif neko
      //log(info('ThreadScheduler'));
      injector.bind(Scheduler,new ThreadScheduler());
    #else 
      //log(info('InlineScheduler'));
      injector.bind(Scheduler,new InlineScheduler());
    #end
  }
  @:noUsing static public inline function option<T>(?v:Null<T>):Option<T>{
    return Options.create(v);
  }
  @:noUsing static public inline function chunk<T>(?v:Null<T>):Chunk<T>{
    return Chunks.create(v);
  }
  @:noUsing static public inline function promise<T>(o:Outcome<T>):Promise<T>{
    return Promise.pure(o);
  }
  @:noUsing static public inline function future<T>(o:T):Future<T>{
    return Future.pure(o);
  }
  @:noUsing static public inline function fail(cde:EnumValue,?pos:PosInfos):Fail{
    return Fail.fail(cde,pos);
  }
  @:noUsing static public inline function except<T>(?pos:haxe.PosInfos):ErrorType -> T{
    return function(err:ErrorType):T{
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
    return stx.test.Assert.assert(v,str,prd,er,pos);
  }
  @:noUsing static public inline function definition<T>(v:T):Class<T>{
    return Types.definition(v);
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
  @:noUsing static public inline function printer<A>(?p:PosInfos):A->Void{
    return stx.io.Log.printer(p);
  }
  @:noUsing static public var noop      = function(){}
  @:noUsing static public function noop1<A>(x:A){
    return x;
  }
  /*@:noUsing static public inline function metadata<T>(v:T):MetaObjectContainer{
    return stx.Meta.metadata(v);
  }*/
  @:noUsing static public function aconstant<T>(v:T){
    return Arrowlet.pure(v);
  }
  @:noUsing static public function fst<A,B>(tp:Tuple2<A,B>):A{
    return tp.fst();
  }
  @:noUsing static public function snd<A,B>(tp:Tuple2<A,B>):B{
    return tp.snd();
  }
}