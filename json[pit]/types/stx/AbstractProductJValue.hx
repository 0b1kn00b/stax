package stx.io.json.types.stx;

import stx.io.json.JValue;
using stx.Tuples;
using stx.Prelude;

class AbstractProductJValue {
	public static function productDecompose(t:Product): JValue {	
    return JArray(t.elements().map(function(t){return Decomposer.getDecomposerFor(Type.typeof(t))(t);}));
  }
}