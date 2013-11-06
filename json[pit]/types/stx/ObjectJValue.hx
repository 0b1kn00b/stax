package stx.io.json.types.stx;

using stx.Prelude;

import stx.io.json.Transcode;


import stx.io.json.JValue;
import stx.Objects;

class ObjectJValue implements Transcode<Object> {
	public function new(){

  }
	public function decompose(d:Dynamic) {
		 return JObject(
				Reflect.fields (d).map (
						function (f) {
							var val = Reflect.field(d, f);
								return JField (f, 
										Decomposer.getDecomposerFor(Type.typeof(val))(val) 
								);
						}
				)
		);
	}
	public function extract(v:JValue):Dynamic {
		switch (v) {
      case JNull:        return null;
      case JString (v):  return v;
      case JNumber (v):  return v;
      case JBool (v):    return v;
      case JArray (xs):  return xs.map(function (x) {return extract(x);});
      case JObject (fs): return fs.foldl({}, function (o: Dynamic, e: JValue) {
        var field = JValues.extractField(e);
        
        Reflect.setField (o, field._1, extract(field._2)); 
        
        return o;
      });
      case JField(k, v): return except()("Cannot convert JField to object");
		}
	}
}