package stx.io.json.types.stx;

import stx.io.json.Transcode;
import stx.io.json.Decomposer;
import stx.io.json.JValue;

import stx.Prelude;

using stx.Options;
using stx.Dynamics;

class OptionJValue<T> extends AbstractTranscode<Option<T>,JExtractorFunction<T>>{
  public function new(){

  }	
  override public function decompose<T>(v: Option<T>): JValue {
    return v.map(function(v) {return Decomposer.getDecomposerForType(Type.typeof(v))(v);}).getOrElse(JNull.toThunk());
  }
  override public function extractWith(v: JValue,e: JExtractorFunction<T>){
    return switch(v) {
      case JNull: None;

      default: Some(e(v));
    }
  }
}