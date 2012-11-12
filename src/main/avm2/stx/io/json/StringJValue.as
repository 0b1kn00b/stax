package stx.io.json {
	import stx.plus.BoolShow;
	import stx.io.json.JValue;
	import stx.plus.FloatShow;
	public class StringJValue {
		static public function decompose(v : String) : stx.io.json.JValue {
			return stx.io.json.JValue.JString(v);
		}
		
		static public function extract(c : Class,val : stx.io.json.JValue) : String {
			return function() : String {
				var $r : String;
				{
					var $e2 : enum = (val);
					switch( $e2.index ) {
					case 2:
					var v : Number = $e2.params[0];
					$r = stx.plus.FloatShow.toString(v);
					break;
					case 1:
					var v1 : Boolean = $e2.params[0];
					$r = stx.plus.BoolShow.toString(v1);
					break;
					case 3:
					var v2 : String = $e2.params[0];
					$r = v2;
					break;
					default:
					$r = Prelude.error("Expected String but found: " + Std.string(val),{ fileName : "PrimitivesJValue.hx", lineNumber : 36, className : "stx.io.json.StringJValue", methodName : "extract"});
					break;
					}
				}
				return $r;
			}();
		}
		
	}
}
