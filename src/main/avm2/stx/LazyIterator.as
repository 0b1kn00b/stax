package stx {
	import stx.Option;
	import stx.Options;
	import flash.Boot;
	public class LazyIterator {
		public function LazyIterator(f : Function = null,stack : Array = null) : void { if( !flash.Boot.skip_constructor ) {
			this.fn = function(i : int) : stx.Option {
				var o : stx.Option = ((stack[i] == null)?stack[i] = f():stack[i]);
				return o;
			}
			this.index = 0;
		}}
		
		public function iterator() : * {
			return { next : this.next, hasNext : this.hasNext}
		}
		
		public function hasNext() : Boolean {
			var o : Boolean = (function($this:LazyIterator) : Boolean {
				var $r : Boolean;
				{
					var $e2 : enum = (($this.fn)($this.index));
					switch( $e2.index ) {
					case 1:
					var v : * = $e2.params[0];
					$r = true;
					break;
					case 0:
					$r = false;
					break;
					}
				}
				return $r;
			}(this));
			return o;
		}
		
		public function next() : * {
			var o : * = stx.Options.get((this.fn)(this.index));
			this.index++;
			return o;
		}
		
		protected var index : int;
		protected var fn : Function;
		static public function create(fn : Function,stack : Array) : stx.LazyIterator {
			return new stx.LazyIterator(fn,stack);
		}
		
	}
}
