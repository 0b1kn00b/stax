package stx.plus {
	import stx.plus.Show;
	import stx.Product;
	public class ProductShow {
		static public function getProductShow(p : stx.Product,i : int) : Function {
			return stx.plus.Show.getShowFor(p.element(i));
		}
		
		static public function toString(p : stx.Product) : String {
			var productPrefix : String = "Tuple" + p.get_length();
			var s : String = productPrefix + "(" + (stx.plus.ProductShow.getProductShow(p,1))(p.element(1));
			{
				var _g1 : int = 2, _g : int = p.get_length() + 1;
				while(_g1 < _g) {
					var i : int = _g1++;
					s += ", " + (stx.plus.ProductShow.getProductShow(p,i))(p.element(i));
				}
			}
			return s + ")";
		}
		
	}
}
