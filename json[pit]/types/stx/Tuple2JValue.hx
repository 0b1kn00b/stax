package stx.io.json.types.stx;

using stx.Tuples;

import stx.io.json.Transcode;
import stx.io.json.Extractor;
import stx.Transformers;

using stx.io.json.types.stx.AbstractProductJValue;

class Tuple2JValue<A,B> extends AbstractTranscode<Tuple2<A,B>,JExtractorFunction2<A,B>>, implements Singleton{
	public function new(){}

  override public function extractWith(v: JValue, ex : JExtractorFunction2<A,B>): Tuple2<A, B> {
    return switch(v) {
      case JArray(v): ex(Tuples.t2(v[0],v[1]));

      default: 
    }
  }
	public function decompose(t:Tuple2<Dynamic,Dynamic>): JValue {
    return t.productDecompose();
  }
}