package stx.io.json.types.stx;

import stx.Tuples;

import stx.io.json.Transcode;

using stx.io.json.types.stx.AbstractProductJValue;


class Tuple4JValue<A,B,C,D> extends  AbstractTranscode<Tuple4<A,B,C,D>,JExtractorFunction4<A,B,C,D>> {
	public static function decompose(t:Tuple4 < Dynamic, Dynamic, Dynamic, Dynamic > ): JValue {
    return t.productDecompose();
  }
  override public function extractWith(v: JValue, ex:JExtractorFunction4<A,B,C,D>):Tuple4<A,B,C,D> {
    return switch(v) {
      case JArray(v): ex(Tuples.t4(v[0],v[1],v[2],v[3]));

      default: Prelude.error()("Expected Array but was: " + v);
    }
  }
}