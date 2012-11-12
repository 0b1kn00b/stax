package stx {
	import stx.Tuple3;
	import stx.Tuples;
	import stx.Entuple;
	import flash.Boot;
	import stx.AbstractProduct;
	public class Tuple2 extends stx.AbstractProduct {
		public function Tuple2(_1 : * = null,_2 : * = null) : void { if( !flash.Boot.skip_constructor ) {
			this._1 = _1;
			this._2 = _2;
			super([_1,_2]);
		}}
		
		public override function get_length() : int {
			return 2;
		}
		
		public override function get_prefix() : String {
			return "stx.Tuple2";
		}
		
		public var _2 : *;
		public var _1 : *;
		static public function entuple(t : stx.Tuple2,c : *) : stx.Tuple3 {
			return new stx.Tuple3(t._1,t._2,c);
		}
		
		static public function into(t : stx.Tuple2,f : Function) : * {
			return f(t._1,t._2);
		}
		
		static public function first(t : stx.Tuple2) : * {
			return t._1;
		}
		
		static public function second(t : stx.Tuple2) : * {
			return t._2;
		}
		
		static public function translate(t : stx.Tuple2,f1 : Function,f2 : Function) : stx.Tuple2 {
			return stx.Entuple.entuple(f1(t._1),f2(t._2));
		}
		
		static public function swap(t : stx.Tuple2) : stx.Tuple2 {
			return stx.Tuples.t2(t._2,t._1);
		}
		
		static public function patch(t0 : stx.Tuple2,t1 : stx.Tuple2) : stx.Tuple2 {
			var _1 : * = ((t1._1 == null)?t0._1:t1._1);
			var _2 : * = ((t1._2 == null)?t0._2:t1._2);
			return stx.Tuples.t2(_1,_2);
		}
		
	}
}
