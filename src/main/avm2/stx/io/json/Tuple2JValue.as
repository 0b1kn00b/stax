package stx.io.json {
	import stx.Tuples;
	import stx.io.json.JValue;
	import stx.io.json.AbstractProductJValue;
	import stx.Tuple2;
	public class Tuple2JValue {
		static public function extract(v : stx.io.json.JValue,e1 : Function,e2 : Function) : stx.Tuple2 {
			return function() : stx.Tuple2 {
				var $r : stx.Tuple2;
				{
					var $e2 : enum = (v);
					switch( $e2.index ) {
					case 4:
					var v1 : Array = $e2.params[0];
					$r = stx.Tuples.t2(e1(v1[0]),e2(v1[1]));
					break;
					default:
					$r = Prelude.error("Expected Array but was: " + Std.string(v),{ fileName : "JValueExtensions.hx", lineNumber : 186, className : "stx.io.json.Tuple2JValue", methodName : "extract"});
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function decompose(t : stx.Tuple2) : stx.io.json.JValue {
			return stx.io.json.AbstractProductJValue.productDecompose(t);
		}
		
	}
}
