package stx.io.json.types.stx;
import stx.Tuples;

import stx.io.json.Transcode;
using stx.io.json.types.stx.AbstractProductJValue;

class Tuple5JValue<A,B,C,D,E> extends AbstractTranscode<Tuple5<A,B,C,D,E>,JExtractorFunction5<A,B,C,D,E>>{
	public function new(){}
	public function decompose(t:Tuple5<Dynamic,Dynamic,Dynamic,Dynamic,Dynamic>): JValue {
    return t.productDecompose();
  }
  public function extractWith(v: JValue, exs : JExtractorFunction5<A,B,C,D,E>):Tuple5<A,B,C,D,E> {
    return switch(v) {
      case JArray(v): Tuples.t5(exs._1(v[0]), exs._2(v[1]), exs._3(v[2]), exs._4(v[3]), exs._5(v[4]));

      default: Prelude.error("Expected Array but was: " + v);
    }
  }
  static public function extractor(){
    return Transcodes.transcoders.get(Type.getClassName(stx.Tuple5)).extract;
  }
  static public function decomposer(){
    return Transcodes.transcoders.get(Type.getClassName(stx.Tuple5)).decompose;
  }
  static public function transcoder(){
    return Transcodes.transcoders.get(Type.getClassName(stx.Tuple5));
  }
}