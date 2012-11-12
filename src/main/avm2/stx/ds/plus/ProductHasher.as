package stx.plus {
	import stx.plus.Hasher;
	import stx.Product;
	public class ProductHasher {
		static public function getHash(p : stx.Product,i : int) : Function {
			return stx.plus.Hasher.getHashFor(p.element(i));
		}
		
		static protected var _baseHashes : Array = [[786433,24593],[196613,3079,389],[1543,49157,196613,97],[12289,769,393241,193,53]];
		static public function hashCode(p : stx.Product) : int {
			var h : int = 0;
			{
				var _g1 : int = 0, _g : int = p.get_length();
				while(_g1 < _g) {
					var i : int = _g1++;
					h += stx.plus.ProductHasher._baseHashes[p.get_length() - 2][i] * (stx.plus.ProductHasher.getHash(p,i))(p.element(i));
				}
			}
			return h;
		}
		
	}
}
