package stx {
	import stx.Tuples;
	import stx.Tuple5;
	import flash.Boot;
	import stx.AbstractProduct;
	public class Tuple4 extends stx.AbstractProduct {
		public function Tuple4(first : * = null,second : * = null,third : * = null,fourth : * = null) : void { if( !flash.Boot.skip_constructor ) {
			super([first,second,third,fourth]);
			this._1 = first;
			this._2 = second;
			this._3 = third;
			this._4 = fourth;
		}}
		
		public function entuple(_5 : *) : stx.Tuple5 {
			return stx.Tuples.t5(this._1,this._2,this._3,this._4,_5);
		}
		
		public override function get_length() : int {
			return 4;
		}
		
		public override function get_prefix() : String {
			return "stx.Tuple4";
		}
		
		public var _4 : *;
		public var _3 : *;
		public var _2 : *;
		public var _1 : *;
		static public function into(t : stx.Tuple4,f : Function) : * {
			return f(t._1,t._2,t._3,t._4);
		}
		
		static public function first(t : stx.Tuple4) : * {
			return t._1;
		}
		
		static public function second(t : stx.Tuple4) : * {
			return t._2;
		}
		
		static public function third(t : stx.Tuple4) : * {
			return t._3;
		}
		
		static public function fourth(t : stx.Tuple4) : * {
			return t._4;
		}
		
		static public function patch(t0 : stx.Tuple4,t1 : stx.Tuple4) : stx.Tuple4 {
			var _1 : * = ((t1._1 == null)?t0._1:t1._1);
			var _2 : * = ((t1._2 == null)?t0._2:t1._2);
			var _3 : * = ((t1._3 == null)?t0._3:t1._3);
			var _4 : * = ((t1._4 == null)?t0._4:t1._4);
			return stx.Tuples.t4(_1,_2,_3,_4);
		}
		
	}
}
