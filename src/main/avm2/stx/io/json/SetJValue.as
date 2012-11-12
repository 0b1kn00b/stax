package stx.io.json {
	import stx.ds.Set;
	import stx.io.json.ArrayJValue;
	import stx.io.json.JValue;
	public class SetJValue {
		static public function decompose(v : stx.ds.Set) : stx.io.json.JValue {
			return stx.io.json.ArrayJValue.decompose(Prelude.SIterables.toArray(v));
		}
		
		static public function extract(v : stx.io.json.JValue,e : Function,order : Function = null,equal : Function = null,hash : Function = null,show : Function = null) : stx.ds.Set {
			return function() : stx.ds.Set {
				var $r : stx.ds.Set;
				{
					var $e2 : enum = (v);
					switch( $e2.index ) {
					case 4:
					var v1 : Array = $e2.params[0];
					$r = stx.ds.Set.create(order,equal,hash,show).addAll(Prelude.SArrays.map(v1,e));
					break;
					default:
					$r = Prelude.error("Expected Array but was: " + Std.string(v),{ fileName : "CollectionsJValue.hx", lineNumber : 40, className : "stx.io.json.SetJValue", methodName : "extract"});
					break;
					}
				}
				return $r;
			}();
		}
		
	}
}
