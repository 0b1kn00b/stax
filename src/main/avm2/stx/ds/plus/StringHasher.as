package stx.plus {
	import stx.Strings;
	public class StringHasher {
		static public function hashCode(v : String) : int {
			var hash : int = 49157;
			{
				var _g1 : int = 0, _g : int = v.length;
				while(_g1 < _g) {
					var i : int = _g1++;
					hash += (24593 + stx.Strings.cca(v,i)) * 49157;
				}
			}
			return hash;
		}
		
	}
}
