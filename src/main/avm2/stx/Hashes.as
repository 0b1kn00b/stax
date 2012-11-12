package stx {
	import stx.Entuple;
	import stx.Tuple2;
	public class Hashes {
		static public function fromHash(h : Hash) : * {
			return Prelude.SIterables.map(Prelude.SIterables.toIterable(h.keys()),function(x : String) : stx.Tuple2 {
				var val : * = h.get(x);
				return stx.Entuple.entuple(x,val);
			});
		}
		
		static public function hasAll(h : Hash,entries : Array) : Boolean {
			var ok : Boolean = true;
			{
				var _g : int = 0;
				while(_g < entries.length) {
					var val : String = entries[_g];
					++_g;
					if(!h.exists(val)) {
						ok = false;
						break;
					}
				}
			}
			return ok;
		}
		
		static public function hasAny(h : Hash,entries : Array) : Boolean {
			{
				var _g : int = 0;
				while(_g < entries.length) {
					var val : String = entries[_g];
					++_g;
					if(h.exists(val)) return true;
				}
			}
			return false;
		}
		
	}
}
