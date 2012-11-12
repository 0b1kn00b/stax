package stx.plus {
	import stx.plus.Equal;
	import stx.Product;
	public class ProductEqual {
		static public function getEqual(p : stx.Product,i : int) : Function {
			return stx.plus.Equal.getEqualFor(p.element(i));
		}
		
		static public function productEquals(p : stx.Product,other : stx.Product) : Boolean {
			{
				var _g1 : int = 0, _g : int = p.get_length();
				while(_g1 < _g) {
					var i : int = _g1++;
					if(!(stx.plus.ProductEqual.getEqualForEqual(p,i))(p.element(i),other.element(i))) return false;
				}
			}
			return true;
		}
		
		static public function equals(p : stx.Product,other : stx.Product) : Boolean {
			{
				var _g1 : int = 0, _g : int = p.get_length();
				while(_g1 < _g) {
					var i : int = _g1++;
					if(!(stx.plus.ProductEqual.getEqualForEqual(p,i))(p.element(i),other.element(i))) return false;
				}
			}
			return true;
		}
		
	}
}
