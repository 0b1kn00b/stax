package stx.io.json.types.stx;

using stx.Tuples;

import stx.io.json.Transcode;
using stx.io.json.types.stx.AbstractProductJValue;

class Tuple3JValue<A,B,C> extends AbstractTranscode<Tuple3<A,B,C>,JExtractorFunction3<A,B,C>>{
  public function new(){}
	public function decompose(t:Tuple3<Dynamic,Dynamic,Dynamic>): JValue {
    return t.productDecompose();
  }
  override public function extractWith(v: JValue, ex : JExtractorFunction3<A,B,C>): Tuple3<A, B, C> {
    return switch(v) {
      case JArray(v): JExtractorFunction2(Tuples.t3(v[0],v[1],v[2]));

      default: except()("Expected Array but was: " + v);
    }
  }
}