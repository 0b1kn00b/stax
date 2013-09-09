package stx;

import stx.Compare.*;

import haxe.ds.StringMap;
import stx.Compare;
import stx.Tuples;

using stx.Options;
using stx.Tuples;
using stx.Functions;
using stx.Compose;
using stx.Prelude;
using stx.Arrays;
using stx.Iterables;

import Type;

typedef Object = {};

/**
  Object defined as {} is different from Dynamic in that it does not allow closures.
*/
class Objects {
  
  @:note('#0b1kn00b: could throw an error')
  @:noUsing static public function asObject(d:Dynamic):Object{
    return cast d;
  }
  static public function toObject<A>(a:Many<KV<A>>):Object{
    return a.foldl(
      {},
      function(init,el){
        Reflect.setField( init , el.fst(), el.snd() );
        return init;
      }
    );
  }
  /**
    Fills first level object keys with fields.
  */
  static public function fill(o:Object,flds:Many<KV<Dynamic>>):Object{
    return cast Tables.replace(cast o,flds);
  }
  /**
    get value as Option.
  */
  static public function getOption(d: Object, k: String): Option<Dynamic> {
    return Tables.getOption(d,k);
  }
  /**
    Return the fields of Object
  */
  static public function fields(o:Object):Array<KV<Dynamic>>{
    return Tables.fields(cast o);
  }
  /**
    Returns the values of the names
  */
  static public function select(d:Object,names:Many<String>):Array<Dynamic>{
    return Tables.select(d,names);
  }
  static public function iterator(d: Object): Iterator<String> {
    return Reflect.fields(d).iterator();
  }
  /**
    The fields exist.
  */
  static public function has(d:Object,flds:Many<String>):Bool{
    return missing(d,flds).isEmpty();
  }
  /**
    Report fields missing.
  */
  static public function missing(d:Object,flds:Many<String>):Option<Array<String>>{
    return Tables.missing(d,flds);
  }
  /**
    The fields are non null.
  */
  static public function defined(d:Object,flds:Many<String>):Bool{
    return fields(d).filter(
      Tuples2.fst.then(eq).then(flds.forAny)
    ).forAll( ntnl() );
  }
  /**
    Merges the first level of object keys into a new Object, right hand override.
  */
  static public function merge(o0:Object,o1:Object):Object{
    return cast Tables.merge(cast o0,cast o1);
  }
  static public function toMap(o:Object):StringMap<Dynamic>{
    var map = new StringMap();
    fields(o).foreach(map.set.spread());
    return map;
  }
  static public function setField(o:Object,k:String,v:Dynamic):Object{
    Reflect.setField(o,k,v);
    return o;
  }
}