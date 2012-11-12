package stx.plus {
	import stx.plus.Order;
	public class ArrayOrder {
		static public function sort(v : Array) : Array {
			return stx.plus.ArrayOrder.sortWith(v,stx.plus.Order.getOrderFor(v[0]));
		}
		
		static public function sortWith(v : Array,order : Function) : Array {
			var r : Array = v.copy();
			r.sort(order);
			return r;
		}
		
		static public function compare(v1 : Array,v2 : Array) : int {
			return stx.plus.ArrayOrder.compareWith(v1,v2,stx.plus.Order.getOrderFor(v1[0]));
		}
		
		static public function compareWith(v1 : Array,v2 : Array,order : Function) : int {
			var c : int = v1.length - v2.length;
			if(c != 0) return c;
			if(v1.length == 0) return 0;
			{
				var _g1 : int = 0, _g : int = v1.length;
				while(_g1 < _g) {
					var i : int = _g1++;
					var c1 : int = order(v1[i],v2[i]);
					if(c1 != 0) return c1;
				}
			}
			return 0;
		}
		
	}
}
