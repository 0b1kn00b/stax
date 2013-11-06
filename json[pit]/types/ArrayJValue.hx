package stx.io.json.types;

import stx.Prelude;

import stx.io.json.Transcode;
import stx.io.json.JValue;
import stx.Transformers;

using stx.Prelude;
using stx.Arrays;
using stx.Options;

class ArrayJValue<T> implements Transcode<Array<T>,JExtractorFunction<T>> {
  public function new(){

  }
  @:todo('#0b1kn00b: v[0] could be null, use find')
  public function decompose(v: Array<T>): JValue {
    return if (v.size() != 0){
      var d = Decomposer.getDecomposerForType(Type.typeof(v[0]));
      JArray(v.map(d));
    }else{
      JArray([]);
    }
  }
  public function extract(v:JValue):Array<T>{
    return
      switch (v) {
        case JArray(v2)  : 
          var el = v2.find( Predicates.isNotNull() ).map( Extractor.getExtractorFor );
          switch (el) {
            case Some(ex) : extractAll(v,cast ex);
            case None     : [];
          }
        default         : except()("Expected Array but was: " + v);
      }
  }
  public function extractAll(v: JValue, e: JExtractorFunction<T>): Array<T> {
    return switch(v) {
      case JArray(v)  : v.map(e);
      default         : except()("Expected Array but was: " + v);
    }
  }
  static public function extractor(){
    return Transcodes.transcoders.get(Type.getClassName(Array)).extract;
  }
  static public function decomposer(){
    return Transcodes.transcoders.get(Type.getClassName(Array)).decompose;
  }
  static public function transcoder(){
    return Transcodes.transcoders.get(Type.getClassName(Array));
  }
}