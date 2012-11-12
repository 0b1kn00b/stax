package stx.io.json {
	import stx.Tuple3;
	import stx.Tuples;
	import stx.io.json.JValue;
	import stx.io.json.AbstractProductJValue;
	public class Tuple3JValue {
		static public function decompose(t : stx.Tuple3) : stx.io.json.JValue {
			return stx.io.json.AbstractProductJValue.productDecompose(t);
		}
		
		static public function extract(v : stx.io.json.JValue,e1 : Function,e2 : Function,e3 : Function) : stx.Tuple3 {
			return function() : stx.Tuple3 {
				var $r : stx.Tuple3;
				{
					var $e2 : enum = (v);
					switch( $e2.index ) {
					case 4:
					var v1 : Array = $e2.params[0];
					$r = stx.Tuples.t3(e1(v1[0]),e2(v1[1]),e3(v1[2]));
					break;
					default:
					$r = Prelude.error("Expected Array but was: " + Std.string(v),{ fileName : "JValueExtensions.hx", lineNumber : 201, className : "stx.io.json.Tuple3JValue", methodName : "extract"});
					break;
					}
				}
				return $r;
			}();
		}
		
	}
}
