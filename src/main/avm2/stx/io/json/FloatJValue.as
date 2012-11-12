package stx.io.json {
	import stx.io.json.JValue;
	import stx.Strings;
	public class FloatJValue {
		static public function decompose(v : Number) : stx.io.json.JValue {
			return stx.io.json.JValue.JNumber(v);
		}
		
		static public function extract(c : Class,v : stx.io.json.JValue) : Number {
			return function() : Number {
				var $r : Number;
				{
					var $e2 : enum = (v);
					switch( $e2.index ) {
					case 2:
					var v1 : Number = $e2.params[0];
					$r = v1;
					break;
					case 3:
					var v2 : String = $e2.params[0];
					$r = stx.Strings.toFloat(v2);
					break;
					default:
					$r = Prelude.error("Expected Float but found: " + Std.string(v),{ fileName : "PrimitivesJValue.hx", lineNumber : 76, className : "stx.io.json.FloatJValue", methodName : "extract"});
					break;
					}
				}
				return $r;
			}();
		}
		
	}
}
