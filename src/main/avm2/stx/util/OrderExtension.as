package stx.util {
	public class OrderExtension {
		static public function greaterThan(order : Function) : Function {
			return function(v1 : *,v2 : *) : Boolean {
				return order(v1,v2) > 0;
			}
		}
		
		static public function greaterThanOrEqual(order : Function) : Function {
			return function(v1 : *,v2 : *) : Boolean {
				return order(v1,v2) >= 0;
			}
		}
		
		static public function lessThan(order : Function) : Function {
			return function(v1 : *,v2 : *) : Boolean {
				return order(v1,v2) < 0;
			}
		}
		
		static public function lessThanOrEqual(order : Function) : Function {
			return function(v1 : *,v2 : *) : Boolean {
				return order(v1,v2) <= 0;
			}
		}
		
		static public function equal(order : Function) : Function {
			return function(v1 : *,v2 : *) : Boolean {
				return order(v1,v2) == 0;
			}
		}
		
		static public function notEqual(order : Function) : Function {
			return function(v1 : *,v2 : *) : Boolean {
				return order(v1,v2) != 0;
			}
		}
		
	}
}
