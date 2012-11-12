package stx {
	import stx.Tuples;
	import flash.Boot;
	import stx.AbstractProduct;
	public class Tuple5 extends stx.AbstractProduct {
		public function Tuple5(first : * = null,second : * = null,third : * = null,fourth : * = null,fifth : * = null) : void { if( !flash.Boot.skip_constructor ) {
			super([first,second,third,fourth,fifth]);
			this._1 = first;
			this._2 = second;
			this._3 = third;
			this._4 = fourth;
			this._5 = fifth;
		}}
		
		public override function get_length() : int {
			return 5;
		}
		
		public override function get_prefix() : String {
			return "stx.Tuple5";
		}
		
		public var _5 : *;
		public var _4 : *;
		public var _3 : *;
		public var _2 : *;
		public var _1 : *;
		static public function into(t : stx.Tuple5,f : Function) : * {
			return f(t._1,t._2,t._3,t._4,t._5);
		}
		
		static public function first(t : stx.Tuple5) : * {
			return t._1;
		}
		
		static public function second(t : stx.Tuple5) : * {
			return t._2;
		}
		
		static public function third(t : stx.Tuple5) : * {
			return t._3;
		}
		
		static public function fourth(t : stx.Tuple5) : * {
			return t._4;
		}
		
		static public function fifth(t : stx.Tuple5) : * {
			return t._5;
		}
		
		static public function patch(t0 : stx.Tuple5,t1 : stx.Tuple5) : stx.Tuple5 {
			var _1 : * = ((t1._1 == null)?t0._1:t1._1);
			var _2 : * = ((t1._2 == null)?t0._2:t1._2);
			var _3 : * = ((t1._3 == null)?t0._3:t1._3);
			var _4 : * = ((t1._4 == null)?t0._4:t1._4);
			var _5 : * = ((t1._5 == null)?t0._5:t1._5);
			return stx.Tuples.t5(_1,_2,_3,_4,_5);
		}
		
	}
}
