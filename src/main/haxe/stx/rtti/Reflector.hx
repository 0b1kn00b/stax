package stx.rtti;

import haxe.ds.StringMap;
import haxe.rtti.CType;

import stx.Fail;
import stx.Fail.*;

using stx.Prelude;
using stx.Compose;
using stx.Either;
using stx.Iterables;
using stx.Option;
using stx.rtti.RTypes;
using stx.Tuples;
using stx.Reflects;

/**
  Reflector uses the rtti types rather than Reflect for operations.
*/
abstract Reflector<C,T>(Tuple2<C,Array<Tuple2<ClassField,T>>>) from Tuple2<C,Array<Tuple2<ClassField,T>>> to Tuple2<C,Array<Tuple2<ClassField,T>>>{
  public function new(v){
    this = v;
  }
  public function get(v:String):Option<T>{
    return this.snd().search(function(x) return x.fst().name == v).map(function(x) return x.snd());
  }
  public function transform(fn:ClassField->Option<T->T>):Reflector<C,T>{
    return tuple2(this.fst(),
      this.snd().map(
        function(tp){
          return fn(tp.fst()).map(
            function(fn0){
              return tuple2(tp.fst(),fn0(tp.snd()));
            }
          ).getOrElseC(tp);
        }
      )
    );
  }
  public function toStringMap():StringMap<T>{
    var m = new StringMap();
    this.snd().foreach(
      function(l:ClassField,r:T){
        m.set(l.name,r);
      }.tupled()
    );
    return m;
  }
  public function call(key:String,?args:Array<Dynamic>):Dynamic{
    return Reflects.callFunction(this.fst(),key,args);
  }
  public function callSafe(key:String,?args:Array<Dynamic>):Option<Dynamic>{
    return Reflects.callSafe(this.fst(),key,args);
  }
  public function callSecure(key:String,?args:Array<Dynamic>):Outcome<Dynamic>{
    return Reflects.callSecure(this.fst(),key,args);
  }
  public function filter(fn:ClassField->Bool):Reflector<C,T>{
    return tuple2(this.fst(),
      this.snd().filter(
        Tuples2.fst.then(fn)
      )
    );
  }
  public function fields():Array<ClassField>{
    return this.snd().map(Tuples2.fst);
  }
}
class Reflectors{
  static public function isMethod(cf:ClassField){
    return switch (cf.type) {
      case CFunction(_,_) : true;
        default           : false;
    }
  }
}