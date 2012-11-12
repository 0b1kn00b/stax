package stx.io.json {
	import stx.io.json.JValue;
	import stx.Strings;
	public class BoolJValue {
		static public function decompose(v : Boolean) : stx.io.json.JValue {
			return stx.io.json.JValue.JBool(v);
		}
		
		static public function extract(c : Class,v : stx.io.json.JValue) : Boolean {
			return function() : Boolean {
				var $r : Boolean;
				{
					var $e2 : enum = (v);
					switch( $e2.index ) {
					case 1:
					var v1 : Boolean = $e2.params[0];
					$r = v1;
					break;
					case 2:
					var v2 : Number = $e2.params[0];
					$r = ((v2 == 0.0)?false:true);
					break;
					case 3:
					var v3 : String = $e2.params[0];
					$r = stx.Strings.toBool(v3);
					break;
					default:
					$r = Prelude.error("Expected Bool but found: " + Std.string(v),{ fileName : "PrimitivesJValue.hx", lineNumber : 50, className : "stx.io.json.BoolJValue", methodName : "extract"});
					break;
					}
				}
				return $r;
			}();
		}
		
	}
}
