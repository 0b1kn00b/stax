package stx.io.json {
	import stx.io.json.JValue;
	import stx.Strings;
	public class DateJValue {
		static public function decompose(v : Date) : stx.io.json.JValue {
			return stx.io.json.JValue.JNumber(v.getTime());
		}
		
		static public function extract(c : Class,v : stx.io.json.JValue) : Date {
			return function() : Date {
				var $r : Date;
				{
					var $e2 : enum = (v);
					switch( $e2.index ) {
					case 2:
					var v1 : Number = $e2.params[0];
					$r = Date["fromTime"](v1);
					break;
					case 3:
					var v2 : String = $e2.params[0];
					$r = Date["fromTime"](stx.Strings.toFloat(v2));
					break;
					default:
					$r = Prelude.error("Expected Number but found: " + Std.string(v),{ fileName : "PrimitivesJValue.hx", lineNumber : 89, className : "stx.io.json.DateJValue", methodName : "extract"});
					break;
					}
				}
				return $r;
			}();
		}
		
	}
}
