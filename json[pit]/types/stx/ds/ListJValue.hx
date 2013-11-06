package stx.io.json.types.stx.ds;

import stx.io.json.Transcode;
import stx.Prelude;
import stx.Predicates;
import stx.ds.List;

using stx.Prelude;
using stx.Arrays;
using stx.Options;

class ListJValue<T> extends AbstractTranscode<List<T>,JExtractorFunction<T>>, implements Singleton{
	public function new(){}

  static public function decompose(l:stx.ds.List<T>): JValue {
    return ArrayJValue.decomposer()(l.toArray());
  }
  override public function extract(v:JValue):stx.ds.List<T>{
    return 
      switch(v) {
        case JArray(xs)  : 
          var valOp                     = xs.find( Predicates.isNotNull() ).get();
          var e : JExtractorFunction<T> = Extractor.getExtractorFor(valOp)  ;

          stx.ds.List.create().addAll(xs.map(e));

        default: except()("Expected Array but was: " + v);
      }
  }
  public function extractAll(v: JValue, e: JExtractorFunction<T>):stx.ds.List<T>{
    return extractAllWith(v,e);
  }
  override public function extractWith(v: JValue, e: JExtractorFunction<T>): stx.ds.List<T> {
    return switch(v) {
      case JArray(v): List.create(tool).addAll(v.map(e));

      default: except()("Expected Array but was: " + v);
    }
  }
  static public function extractor(){
    return Transcodes.transcoders.get(Type.getClassName(stx.ds.List)).extract;
  }
  static public function decomposer(){
    return Transcodes.transcoders.get(Type.getClassName(stx.ds.List)).decompose;
  }
  static public function transcoder(){
    return Transcodes.transcoders.get(Type.getClassName(stx.ds.List)); 
  }
}