package stx {
	import stx.Tuple2;
	import stx.Product;
	import stx.Tuple3;
	import stx.Tuple4;
	import stx.plus.Show;
	import stx.Tuple5;
	import flash.Boot;
	public class AbstractProduct implements stx.Product{
		public function AbstractProduct(elements : Array = null) : void { if( !flash.Boot.skip_constructor ) {
			this._elements = elements;
		}}
		
		public function flatten() : Array {
			var flatn : Function = null;
			flatn = function(p : stx.Product) : Array {
				return Prelude.SArrays.flatMap(p.elements(),function(v : stx.Product) : Array {
					return ((Std._is(v,stx.Product))?Prelude.SArrays.flatMap(flatn(v),Prelude.unfold
Prelude.unfold()):[v]);
				});
			}
			return flatn(this);
		}
		
		public function elements() : Array {
			return (function($this:AbstractProduct) : Array {
				var $r : Array;
				switch($this.get_length()) {
				case 5:
				$r = (function($this:AbstractProduct) : Array {
					var $r2 : Array;
					var p : stx.Tuple5 = $this;
					$r2 = [p._1,p._2,p._3,p._4,p._5];
					return $r2;
				}($this));
				break;
				case 4:
				$r = (function($this:AbstractProduct) : Array {
					var $r3 : Array;
					var p1 : stx.Tuple4 = $this;
					$r3 = [p1._1,p1._2,p1._3,p1._4];
					return $r3;
				}($this));
				break;
				case 3:
				$r = (function($this:AbstractProduct) : Array {
					var $r4 : Array;
					var p2 : stx.Tuple3 = $this;
					$r4 = [p2._1,p2._2,p2._3];
					return $r4;
				}($this));
				break;
				case 2:
				$r = (function($this:AbstractProduct) : Array {
					var $r5 : Array;
					var p3 : stx.Tuple2 = $this;
					$r5 = [p3._1,p3._2];
					return $r5;
				}($this));
				break;
				}
				return $r;
			}(this));
		}
		
		public function get_length() : int {
			return Prelude.error("Not implemented",{ fileName : "Tuples.hx", lineNumber : 69, className : "stx.AbstractProduct", methodName : "get_length"});
		}
		
		public function get_prefix() : String {
			return Prelude.error("Not implemented",{ fileName : "Tuples.hx", lineNumber : 65, className : "stx.AbstractProduct", methodName : "get_prefix"});
		}
		
		public function toString() : String {
			var s : String = this.get_prefix() + "(" + (stx.plus.Show.getShowFor(this.element(0)))(this.element(0));
			{
				var _g1 : int = 1, _g : int = this.get_length();
				while(_g1 < _g) {
					var i : int = _g1++;
					s += ", " + (stx.plus.Show.getShowFor(this.element(i)))(this.element(i));
				}
			}
			return s + ")";
		}
		
		public function element(n : int) : * {
			return this._elements[n];
		}
		
		public var _elements : Array;
		public function get length() : int { return get_length(); }
		protected function set length( __v : int ) : void { $length = __v; }
		protected var $length : int;
		public function get prefix() : String { return get_prefix(); }
		protected function set prefix( __v : String ) : void { $prefix = __v; }
		protected var $prefix : String;
		protected var tools : Array;
	}
}
