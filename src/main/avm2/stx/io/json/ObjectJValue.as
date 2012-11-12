package stx.io.json {
	import stx.io.json.JValueExtensions;
	import stx.io.json.TranscodeJValue;
	import stx.io.json.JValue;
	import stx.Tuple2;
	public class ObjectJValue {
		static public function decompose(d : *) : stx.io.json.JValue {
			return stx.io.json.JValue.JObject(Prelude.SArrays.map(Reflect.fields(d),function(f : String) : stx.io.json.JValue {
				var val : * = Reflect.field(d,f);
				return stx.io.json.JValue.JField(f,(stx.io.json.TranscodeJValue.getDecomposerFor(Type._typeof(val)))(val));
			}));
		}
		
		static public function extract(v : stx.io.json.JValue) : * {
			{
				var $e : enum = (v);
				switch( $e.index ) {
				case 0:
				return null;
				break;
				case 3:
				var v1 : String = $e.params[0];
				return v1;
				break;
				case 2:
				var v2 : Number = $e.params[0];
				return v2;
				break;
				case 1:
				var v3 : Boolean = $e.params[0];
				return v3;
				break;
				case 4:
				var xs : Array = $e.params[0];
				return Prelude.SArrays.map(xs,function(x : stx.io.json.JValue) : * {
					return stx.io.json.ObjectJValue.extract(x);
				});
				break;
				case 5:
				var fs : Array = $e.params[0];
				return Prelude.SArrays.foldl(fs,{ },function(o : *,e : stx.io.json.JValue) : * {
					var field : stx.Tuple2 = stx.io.json.JValueExtensions.extractField(e);
					Reflect.setField(o,field._1,stx.io.json.ObjectJValue.extract(field._2));
					return o;
				});
				break;
				case 6:
				var v4 : stx.io.json.JValue = $e.params[1], k : String = $e.params[0];
				return Prelude.error("Cannot convert JField to object",{ fileName : "PrimitivesJValue.hx", lineNumber : 120, className : "stx.io.json.ObjectJValue", methodName : "extract"});
				break;
				}
			}
			return null;
		}
		
	}
}
