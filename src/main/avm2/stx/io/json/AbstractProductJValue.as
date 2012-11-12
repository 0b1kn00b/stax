package stx.io.json {
	import stx.io.json.TranscodeJValue;
	import stx.io.json.JValue;
	import stx.Product;
	public class AbstractProductJValue {
		static public function productDecompose(t : stx.Product) : stx.io.json.JValue {
			return stx.io.json.JValue.JArray(Prelude.SArrays.map(t.elements(),function(t1 : *) : stx.io.json.JValue {
				return (stx.io.json.TranscodeJValue.getDecomposerFor(Type._typeof(t1)))(t1);
			}));
		}
		
	}
}
