package stx.io.json {
	import stx.Dynamics;
	import stx.Option;
	import stx.io.json.TranscodeJValue;
	import stx.Options;
	import stx.io.json.JValue;
	public class OptionJValue {
		static public function decompose(v : stx.Option) : stx.io.json.JValue {
			return stx.Options.getOrElse(stx.Options.map(v,function(v1 : *) : stx.io.json.JValue {
				return (stx.io.json.TranscodeJValue.getDecomposerFor(Type._typeof(v1)))(v1);
			}),stx.Dynamics.toThunk(stx.io.json.JValue.JNull));
		}
		
		static public function extract(c : Class,v : stx.io.json.JValue,e : Function) : stx.Option {
			return function() : stx.Option {
				var $r : stx.Option;
				{
					var $e2 : enum = (v);
					switch( $e2.index ) {
					case 0:
					$r = stx.Option.None;
					break;
					default:
					$r = stx.Option.Some(e(v));
					break;
					}
				}
				return $r;
			}();
		}
		
	}
}
