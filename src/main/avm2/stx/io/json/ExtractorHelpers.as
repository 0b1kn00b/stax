package stx.io.json {
	import stx.Dynamics;
	import stx.io.json.JValueExtensions;
	import stx.io.json.JValue;
	public class ExtractorHelpers {
		static public function extractFieldValue(j : stx.io.json.JValue,n : String,e : Function,def : stx.io.json.JValue) : * {
			var fieldValue : stx.io.json.JValue = stx.io.json.JValueExtensions.getOrElse(j,n,stx.Dynamics.toThunk(def));
			try {
				return e(fieldValue);
			}
			catch( err : * ){
				return e(def);
			}
			return null;
		}
		
	}
}
