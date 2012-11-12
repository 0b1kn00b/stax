package stx {
	import stx.Strings;
	public class StringPredicates {
		static public function startsWith(s : String) : Function {
			return function(value : String) : Boolean {
				return stx.Strings.startsWith(value,s);
			}
		}
		
		static public function endsWith(s : String) : Function {
			return function(value : String) : Boolean {
				return stx.Strings.endsWith(value,s);
			}
		}
		
		static public function contains(s : String) : Function {
			return function(value : String) : Boolean {
				return stx.Strings.contains(value,s);
			}
		}
		
	}
}
