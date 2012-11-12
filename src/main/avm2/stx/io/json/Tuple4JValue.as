package stx.io.json {
	import stx.Tuples;
	import stx.io.json.JValue;
	import stx.Tuple4;
	import stx.io.json.AbstractProductJValue;
	public class Tuple4JValue {
		static public function decompose(t : stx.Tuple4) : stx.io.json.JValue {
			return stx.io.json.AbstractProductJValue.productDecompose(t);
		}
		
		static public function extract(v : stx.io.json.JValue,e1 : Function,e2 : Function,e3 : Function,e4 : Function) : stx.Tuple4 {
			return function() : stx.Tuple4 {
				var $r : stx.Tuple4;
				{
					var $e2 : enum = (v);
					switch( $e2.index ) {
					case 4:
					var v1 : Array = $e2.params[0];
					$r = stx.Tuples.t4(e1(v1[0]),e2(v1[1]),e3(v1[2]),e4(v1[3]));
					break;
					default:
					$r = Prelude.error("Expected Array but was: " + Std.string(v),{ fileName : "JValueExtensions.hx", lineNumber : 213, className : "stx.io.json.Tuple4JValue", methodName : "extract"});
					break;
					}
				}
				return $r;
			}();
		}
		
	}
}
