package stx.plus {
	import stx.plus.Hasher;
	public class ArrayHasher {
		static public function hashCode(v : Array) : int {
			return stx.plus.ArrayHasher.hashCodeWith(v,stx.plus.Hasher.getHashFor(v[0]));
		}
		
		static public function hashCodeWith(v : Array,hash : Function) : int {
			var h : int = 12289;
			if(v.length == 0) return h;
			{
				var _g1 : int = 0, _g : int = v.length;
				while(_g1 < _g) {
					var i : int = _g1++;
					h += hash(v[i]) * 12289;
				}
			}
			return h;
		}
		
	}
}
