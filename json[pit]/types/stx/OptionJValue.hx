package stx.io.json.types.stx;

import stx.io.json.Transcode;
import stx.io.json.Decomposer;
import stx.io.json.JValue;

import stx.Prelude;

using stx.Maybes;
using stx.Dynamics;

class MaybeJValue<T> extends AbstractTranscode<Maybe<T>,JExtractorFunction<T>>{
  public function new(){

  }	
  override public function decompose<T>(v: Maybe<T>): JValue {
    return v.map(function(v) {return Decomposer.getDecomposerForType(Type.typeof(v))(v);}).getOrElse(JNull.toThunk());
  }
  override public function extractWith(v: JValue,e: JExtractorFunction<T>){
    return switch(v) {
      case JNull: None;

      default: Some(e(v));
    }
  }
}