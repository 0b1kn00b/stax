package stx.io.json {
	import stx.plus.StringHasher;
	import stx.io.json.TranscodeJValue;
	import stx.io.json.JValue;
	import stx.ds.Map;
	import stx.Tuple2;
	import stx.Strings;
	import stx.Tuples;
	public class MapOps {
		static public function stringKeyDecompose(v : stx.ds.Map) : stx.io.json.JValue {
			var it : * = v.iterator();
			if(it.hasNext()) {
				var dv : Function = stx.io.json.TranscodeJValue.getDecomposerFor(Type._typeof(it.next()._2));
				return stx.io.json.JValue.JObject(Prelude.SArrays.map(Prelude.SIterables.toArray(v),function(t : stx.Tuple2) : stx.io.json.JValue {
					return stx.io.json.JValue.JField(t._1,dv(t._2));
				}));
			}
			else return stx.io.json.JValue.JObject([]);
			return null;
		}
		
		static public function stringKeyExtract(v : stx.io.json.JValue,ve : Function,vorder : Function = null,vequal : Function = null,vhash : Function = null,vshow : Function = null) : stx.ds.Map {
			var extract0 : Function = function(v1 : Array) : stx.ds.Map {
				return stx.ds.Map.create(stx.Strings.compare,stx.Strings.equals,stx.plus.StringHasher.hashCode,stx.Strings.toString,vorder,vequal,vhash,vshow).addAll(Prelude.SArrays.map(v1,function(j : stx.io.json.JValue) : stx.Tuple2 {
					return function() : stx.Tuple2 {
						var $r : stx.Tuple2;
						{
							var $e2 : enum = (j);
							switch( $e2.index ) {
							case 6:
							var v2 : stx.io.json.JValue = $e2.params[1], k : String = $e2.params[0];
							$r = stx.Tuples.t2(k,ve(v2));
							break;
							default:
							$r = Prelude.error("Expected field but was: " + Std.string(v1),{ fileName : "TranscodeJValueExtensions.hx", lineNumber : 76, className : "stx.io.json.MapOps", methodName : "stringKeyExtract"});
							break;
							}
						}
						return $r;
					}();
				}));
			}
			return function() : stx.ds.Map {
				var $r3 : stx.ds.Map;
				{
					var $e4 : enum = (v);
					switch( $e4.index ) {
					case 5:
					var v3 : Array = $e4.params[0];
					$r3 = extract0(v3);
					break;
					case 4:
					var v4 : Array = $e4.params[0];
					$r3 = extract0(v4);
					break;
					default:
					$r3 = Prelude.error("Expected either Array or Object but was: " + Std.string(v),{ fileName : "TranscodeJValueExtensions.hx", lineNumber : 85, className : "stx.io.json.MapOps", methodName : "stringKeyExtract"});
					break;
					}
				}
				return $r3;
			}();
		}
		
	}
}
