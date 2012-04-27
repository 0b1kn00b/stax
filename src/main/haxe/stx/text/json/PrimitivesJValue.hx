package stx.text.json;

/**
 * ...
 * @author 0b1kn00b
 */
using Stax;

import stx.data.transcode.TranscodeJValue;
import stx.data.transcode.TranscodeJValueExtensions;
import stx.text.json.JValue;

using stx.ds.plus.Show;

import stx.Maths;
using stx.Maths;

import stx.Strings;
using stx.Strings;

 
 
class PrimitivesJValue {
	
}
class StringJValue {
	public static function decompose(v: String): JValue {
    return JString(v);
  }
  public static function extract(c: Class<String>, v: JValue): String {
    return switch(v) {
      case JNumber(v): v.toString();
      case JBool(v): v.toString();
      case JString(v): v;

      default: Stax.error("Expected String but found: " + v);
    }
  }
}
class BoolJValue {
  public static function decompose(v: Bool): JValue {
    return JBool(v);
  }
  public static function extract(c : Enum<Bool>, v: JValue): Bool {
    return switch(v) {
      case JBool(v): v;
      case JNumber(v): if (v == 0.0) false; else true;
      case JString(v): v.toBool();

      default: Stax.error("Expected Bool but found: " + v);
    }
  }	
}
class IntJValue {
	public static function decompose(v: Int): JValue {
    return JNumber(v);
  }
  public static function extract(c: Class<Int>, v: JValue): Int {
    return switch(v) {
      case JNumber(v): v.int();
      case JString(v): v.int();

      default: Stax.error("Expected Int but found: " + v);
    }
  }
}
class FloatJValue {
  public static function decompose(v: Float): JValue{
    return JNumber(v);
  }
  public static function extract(c: Class<Float>, v: JValue): Float{
    return switch(v) {
      case JNumber(v): v;
      case JString(v): v.toFloat();

      default: Stax.error("Expected Float but found: " + v);
    }
  }	
}
class DateJValue {
  public static function decompose(v: Date): JValue {
    return JNumber(v.getTime());
  }
  public static function extract(c: Class<Date>, v: JValue): Date {
    return switch(v) {
      case JNumber(v): Date.fromTime(v);
      case JString(v): Date.fromTime(v.toFloat());

      default: Stax.error("Expected Number but found: " + v);
    }
  }	
}
class ObjectJValue {
	public static function decompose(d:Dynamic) {
		 return JObject(
				Reflect.fields (d).map (
						function (f) {
							var val = Reflect.field(d, f);
								return JField (f, 
										TranscodeJValue.getDecomposerFor(Type.typeof(val))(val) 
								);
						}
				)
		);
	}
	public static function extract(v:JValue):Dynamic {
		switch (v) {
      case JNull:        return null;
      case JString (v):  return v;
      case JNumber (v):  return v;
      case JBool (v):    return v;
      case JArray (xs):  return xs.map(function (x) {return extract(x);});
      case JObject (fs): return fs.foldl({}, function (o: Dynamic, e: JValue) {
        var field = JValueExtensions.extractField(e);
        
        Reflect.setField (o, field._1, extract(field._2)); 
        
        return o;
      });
      case JField(k, v): return Stax.error("Cannot convert JField to object");
		}
	}
}
class ArrayJValue {
  public static function decompose<T>(v: Array<T>): JValue {
    return if (v.size() != 0){
      var d = TranscodeJValue.getDecomposerFor(Type.typeof(v[0]));
      JArray(v.map(d));
    }
    else{
      JArray([]);
    }
  }	
  public static function extract<T>(c: Class<Array<Dynamic>>, v: JValue, e: JExtractorFunction<T>): Array<T> {
    return switch(v) {
      case JArray(v): v.map(e);

      default: Stax.error("Expected Array but was: " + v);
    }
  }	
}
