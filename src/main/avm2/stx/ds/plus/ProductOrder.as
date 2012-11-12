package stx.plus {
	import stx.plus.Order;
	import stx.Product;
	public class ProductOrder {
		static public function getOrder(p : stx.Product,i : int) : Function {
			return stx.plus.Order.getOrderFor(p.element(i));
		}
		
		static public function compare(one : stx.Product,other : stx.Product) : int {
			{
				var _g1 : int = 0, _g : int = one.get_length();
				while(_g1 < _g) {
					var i : int = _g1++;
					var c : int = (stx.plus.ProductOrder.getOrder(one,i))(one.element(i),other.element(i));
					if(c != 0) return c;
				}
			}
			return 0;
		}
		
	}
}
