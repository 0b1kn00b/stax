package stx {
	import stx.Tuple3;
	import stx.Tuple4;
	import stx.Product;
	import stx.Tuple5;
	import stx.Tuple2;
	public class Tuples {
		static public function t2(_1 : *,_2 : *) : stx.Tuple2 {
			return new stx.Tuple2(_1,_2);
		}
		
		static public function t3(_1 : *,_2 : *,_3 : *) : stx.Tuple3 {
			return new stx.Tuple3(_1,_2,_3);
		}
		
		static public function t4(_1 : *,_2 : *,_3 : *,_4 : *) : stx.Tuple4 {
			return new stx.Tuple4(_1,_2,_3,_4);
		}
		
		static public function t5(_1 : *,_2 : *,_3 : *,_4 : *,_5 : *) : stx.Tuple5 {
			return new stx.Tuple5(_1,_2,_3,_4,_5);
		}
		
		static public function elements(p : stx.Product) : Array {
			return p.elements();
		}
		
	}
}
