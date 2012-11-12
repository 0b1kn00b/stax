package stx {
	import stx.Tuple2;
	import stx.AbstractProduct;
	import stx.Entuple;
	import stx.Tuples;
	import stx.Tuple4;
	import flash.Boot;
	public class Tuple3 extends stx.AbstractProduct {
		public function Tuple3(_1 : * = null,_2 : * = null,_3 : * = null) : void { if( !flash.Boot.skip_constructor ) {
			this._1 = _1;
			this._2 = _2;
			this._3 = _3;
			super([_1,_2,_3]);
		}}
		
		public override function get_length() : int {
			return 3;
		}
		
		public override function get_prefix() : String {
			return "stx.Tuple3";
		}
		
		public var _3 : *;
		public var _2 : *;
		public var _1 : *;
		static public function into(t : stx.Tuple3,f : Function) : * {
			return f(t._1,t._2,t._3);
		}
		
		static public function translate(t : stx.Tuple3,f1 : Function,f2 : Function,f3 : Function) : stx.Tuple3 {
			return stx.Tuple2.entuple(stx.Entuple.entuple(f1(t._1),f2(t._2)),f3(t._3));
		}
		
		static public function entuple(t : stx.Tuple3,d : *) : stx.Tuple4 {
			return new stx.Tuple4(t._1,t._2,t._3,d);
		}
		
		static public function first(t : stx.Tuple2) : * {
			return t._1;
		}
		
		static public function second(t : stx.Tuple2) : * {
			return t._2;
		}
		
		static public function third(t : stx.Tuple3) : * {
			return t._3;
		}
		
		static public function patch(t0 : stx.Tuple3,t1 : stx.Tuple3) : stx.Tuple3 {
			var _1 : * = ((t1._1 == null)?t0._1:t1._1);
			var _2 : * = ((t1._2 == null)?t0._2:t1._2);
			var _3 : * = ((t1._3 == null)?t0._3:t1._3);
			return stx.Tuples.t3(_1,_2,_3);
		}
		
	}
}
