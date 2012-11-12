package stx.io.json {
	import stx.io.json.TranscodeJValue;
	import stx.io.json.JValue;
	public class ArrayJValue {
		static public function decompose(v : Array) : stx.io.json.JValue {
			return ((Prelude.SArrays.size(v) != 0)?function() : stx.io.json.JValue {
				var $r : stx.io.json.JValue;
				var d : Function = stx.io.json.TranscodeJValue.getDecomposerFor(Type._typeof(v[0]));
				$r = stx.io.json.JValue.JArray(Prelude.SArrays.map(v,d));
				return $r;
			}():stx.io.json.JValue.JArray([]));
		}
		
		static public function extract(c : Class,v : stx.io.json.JValue,e : Function) : Array {
			return function() : Array {
				var $r : Array;
				{
					var $e2 : enum = (v);
					switch( $e2.index ) {
					case 4:
					var v1 : Array = $e2.params[0];
					$r = Prelude.SArrays.map(v1,e);
					break;
					default:
					$r = Prelude.error("Expected Array but was: " + Std.string(v),{ fileName : "PrimitivesJValue.hx", lineNumber : 138, className : "stx.io.json.ArrayJValue", methodName : "extract"});
					break;
					}
				}
				return $r;
			}();
		}
		
	}
}
