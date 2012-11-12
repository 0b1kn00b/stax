package stx.io.json {
	import stx.io.json.Tuple2JValue;
	import stx.io.json.ArrayJValue;
	import stx.io.json.JValue;
	import stx.ds.Map;
	import stx.Tuple2;
	public class MapJValue {
		static public function decompose(v : stx.ds.Map) : stx.io.json.JValue {
			return stx.io.json.ArrayJValue.decompose(Prelude.SIterables.toArray(v));
		}
		
		static public function extract(v : stx.io.json.JValue,ke : Function,ve : Function,korder : Function = null,kequal : Function = null,khash : Function = null,kshow : Function = null,vorder : Function = null,vequal : Function = null,vhash : Function = null,vshow : Function = null) : stx.ds.Map {
			var te : Function = function(abc : stx.io.json.JValue) : stx.Tuple2 {
				return stx.io.json.Tuple2JValue.extract(abc,ke,ve);
			}
			return function() : stx.ds.Map {
				var $r : stx.ds.Map;
				{
					var $e2 : enum = (v);
					switch( $e2.index ) {
					case 4:
					var v1 : Array = $e2.params[0];
					$r = stx.ds.Map.create(korder,kequal,khash,kshow,vorder,vequal,vhash,vshow).addAll(Prelude.SArrays.map(v1,te));
					break;
					default:
					$r = Prelude.error("Expected Array but was: " + Std.string(v),{ fileName : "CollectionsJValue.hx", lineNumber : 68, className : "stx.io.json.MapJValue", methodName : "extract"});
					break;
					}
				}
				return $r;
			}();
		}
		
	}
}
