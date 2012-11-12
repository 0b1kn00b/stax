package stx.io.json {
	import stx.io.json.JValue;
	import stx.Strings;
	import stx.Floats;
	public class IntJValue {
		static public function decompose(v : int) : stx.io.json.JValue {
			return stx.io.json.JValue.JNumber(v);
		}
		
		static public function extract(c : Class,v : stx.io.json.JValue) : int {
			return function() : int {
				var $r : int;
				{
					var $e2 : enum = (v);
					switch( $e2.index ) {
					case 2:
					var v1 : Number = $e2.params[0];
					$r = stx.Floats._int(v1);
					break;
					case 3:
					var v2 : String = $e2.params[0];
					$r = stx.Strings._int(v2);
					break;
					default:
					$r = Prelude.error("Expected Int but found: " + Std.string(v),{ fileName : "PrimitivesJValue.hx", lineNumber : 63, className : "stx.io.json.IntJValue", methodName : "extract"});
					break;
					}
				}
				return $r;
			}();
		}
		
	}
}
