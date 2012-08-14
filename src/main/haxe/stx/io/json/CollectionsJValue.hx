package stx.io.json;

/**
 * ...
 * @author 0b1kn00b
 */
import stx.Tuples;
import stx.Prelude;

using SCore;

import stx.ds.Set;
import stx.ds.List;
import stx.ds.Map;
import stx.io.json.TranscodeJValue;


import stx.io.json.PrimitivesJValue;
using stx.io.json.PrimitivesJValue;
using stx.io.json.CollectionsJValue;
using stx.io.json.JValueExtensions;
import stx.io.json.JValueExtensions;

class CollectionsJValue {

	public function new() {
		
	}
	
}
class SetJValue {
  public static function decompose<T>(v:Set<T>): JValue {
    return ArrayJValue.decompose(v.toArray());
  }

  public static function extract<T>(v: JValue, e: JExtractorFunction<T>, ?order: OrderFunction<T>, ?equal: EqualFunction<T>, ?hash: HashFunction<T>, ?show: ShowFunction<T>): Set<T> {
    return switch(v) {
      case JArray(v): Set.create(order, equal, hash, show).addAll(v.map(e));

      default: SCore.error("Expected Array but was: " + v);
    }
  }	
}
class ListJValue {
  public static function decompose<T>(l:stx.ds.List<T>): JValue {
    return ArrayJValue.decompose(l.toArray());
  }

  public static function extract<A>(v: JValue, e: JExtractorFunction<A>,?tool:CollectionTools<A>): List<A> {
    return switch(v) {
      case JArray(v): List.create(tool).addAll(v.map(e));

      default: SCore.error("Expected Array but was: " + v);
    }
  }	
}
class MapJValue {
	public static function decompose<K,V>(v:Map<K,V>): JValue {
    return ArrayJValue.decompose(v.toArray());
  }

  public static function extract<K, V>(v: JValue, ke: JExtractorFunction<K>, ve: JExtractorFunction<V>, ?korder : OrderFunction<K>, ?kequal: EqualFunction<K>, ?khash: HashFunction<K>, ?kshow : ShowFunction<K>, ?vorder : OrderFunction<V>, ?vequal: EqualFunction<V>, ?vhash: HashFunction<V>, ?vshow : ShowFunction<V>): Map<K, V> {
    var te = function(abc){return Tuple2JValue.extract(abc,ke, ve);};

    return switch(v) {
      case JArray(v): Map.create(korder, kequal, khash, kshow, vorder, vequal, vhash, vshow).addAll(v.map(te));

      default: SCore.error("Expected Array but was: " + v);
    }
  }
}