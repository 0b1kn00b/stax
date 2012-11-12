package stx.io.json {
	import stx.Tuples;
	import stx.io.json.JValue;
	import stx.io.json.AbstractProductJValue;
	import stx.Tuple5;
	public class Tuple5JValue {
		static public function decompose(t : stx.Tuple5) : stx.io.json.JValue {
			return stx.io.json.AbstractProductJValue.productDecompose(t);
		}
		
		static public function extract(v : stx.io.json.JValue,e1 : Function,e2 : Function,e3 : Function,e4 : Function,e5 : Function) : stx.Tuple5 {
			return function() : stx.Tuple5 {
				var $r : stx.Tuple5;
				{
					var $e2 : enum = (v);
					switch( $e2.index ) {
					case 4:
					var v1 : Array = $e2.params[0];
					$r = stx.Tuples.t5(e1(v1[0]),e2(v1[1]),e3(v1[2]),e4(v1[3]),e5(v1[4]));
					break;
					default:
					$r = Prelude.error("Expected Array but was: " + Std.string(v),{ fileName : "JValueExtensions.hx", lineNumber : 225, className : "stx.io.json.Tuple5JValue", methodName : "extract"});
					break;
					}
				}
				return $r;
			}();
		}
		
	}
}
