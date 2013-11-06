package stx.io.json.types.stx.ds;

import stx.Prelude;
import stx.io.json.Transcode;
import stx.ds.Map;
import stx.io.json.Decomposer;
import stx.io.json.JValue;
using stx.Tuples;
import stx.Transformers;

using stx.Prelude;
using stx.Arrays;
using stx.Options;
using stx.Functions;

class MapJValue<K,V> extends AbstractTranscode<Map<K,V>,JExtractorFunction2<K,V>>{
  public function new(){

  }
  override public function decompose(v:Map<K,V>): JValue {
    return ArrayJValue.decomposer()(v.toArray());
  }
  override public function extractWith(v: JValue, e:JExtractorFunction2)
    return 
      switch(v) {
        case JArray(xs)       :
          var map = Map.create();
              map.addAll(
                xs.map( Tuple2JValue.extractWith.p2(e) )
              );
          }
        default: except()("Expected Array but was: " + v);
      }
  }
  static public function stringKeyDecompose<V>(v: Map<String, V>): JValue {
    var it = v.iterator();
    if(it.hasNext()) {
      var dv = Decomposer.getDecomposerForType(Type.typeof(it.next()._2));
      return JObject(v.toArray().map(function(t) {return JField(t._1, dv(t._2));}));
    }
    else{
      return JObject([]);
    }
  }

  static public function stringKeyExtract<V>(v: JValue, ve: JExtractorFunction<V>, ?vorder : Reduce<V,Int>, ?vequal: Reduce<V,Bool>, ?vhash: MapFunction<V>, ?vshow : V->String): Map<String, V> {
    var extract0 = function(v: Array<JValue>){
      return Map.create(Strings.compare, Strings.equals, StringHasher.hashCode, Strings.toString, vorder, vequal, vhash, vshow).addAll(v.map(function(j) {
        return switch(j) {
          case JField(k, v): tuple2(k, ve(v));

          default: except()("Expected field but was: " + v);
        }
      }));
    }

    return switch(v) {
      case JObject(v): extract0(v);
      case JArray(v) : extract0(v);

      default: except()("Expected either Array or Object but was: " + v);
    }
  }
}