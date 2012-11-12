package stx.io.json {
	import stx.io.json.ArrayJValue;
	import stx.io.json.JValue;
	import stx.ds.List;
	public class ListJValue {
		static public function decompose(l : stx.ds.List) : stx.io.json.JValue {
			return stx.io.json.ArrayJValue.decompose(Prelude.SIterables.toArray(l));
		}
		
		static public function extract(v : stx.io.json.JValue,e : Function,tool : * = null) : stx.ds.List {
			return function() : stx.ds.List {
				var $r : stx.ds.List;
				{
					var $e2 : enum = (v);
					switch( $e2.index ) {
					case 4:
					var v1 : Array = $e2.params[0];
					$r = stx.ds.List.create(tool).addAll(Prelude.SArrays.map(v1,e));
					break;
					default:
					$r = Prelude.error("Expected Array but was: " + Std.string(v),{ fileName : "CollectionsJValue.hx", lineNumber : 53, className : "stx.io.json.ListJValue", methodName : "extract"});
					break;
					}
				}
				return $r;
			}();
		}
		
	}
}
