package stx.io.json.types.stx.ds;

import stx.ds.Set;
using stx.Tuples;
import stx.io.json.Transcode;
import stx.Prelude;
import stx.Transformers;

using stx.Prelude;

class SetJValue<T> extends AbstractTranscode<Set<T>,JExtractorFunction<T>>{
	public function new(){

	}
  override public function decompose<T>(v:Set<T>): JValue {
    return ArrayJValue.decomposer()(v.toArray());
  }
  override public function extractWith(v:JValue,e: JExtractorFunction<T>){
  	return 
      switch(v) {
        case JArray(xs)       :
          Set.create().addAll( xs.map(e) );
        default: Prelude.error()("Expected Array but was: " + v);
      }
  }
}