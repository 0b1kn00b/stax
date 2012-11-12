package  {
	import stx.Option;
	import stx.Options;
	import stx.Tuple2;
	public class Stax {
		static public function here(pos : * = null) : * {
			return pos;
		}
		
		static public function tool(order : Function = null,equal : Function = null,hash : Function = null,show : Function = null) : * {
			return { order : order, equal : equal, show : show, hash : hash}
		}
		
		static public function noop0() : Function {
			return function() : void {
			}
		}
		
		static public function noop1() : Function {
			return function(a : *) : void {
			}
		}
		
		static public function noop2() : Function {
			return function(a : *,b : *) : void {
			}
		}
		
		static public function noop3() : Function {
			return function(a : *,b : *,c : *) : void {
			}
		}
		
		static public function noop4() : Function {
			return function(a : *,b : *,c : *,d : *) : void {
			}
		}
		
		static public function noop5() : Function {
			return function(a : *,b : *,c : *,d : *,e : *) : void {
			}
		}
		
		static public function identity() : Function {
			return function(a : *) : * {
				return a;
			}
		}
		
		static public function unfold(initial : *,unfolder : Function) : * {
			return { iterator : function() : * {
				var _next : stx.Option = stx.Option.None;
				var _progress : * = initial;
				var precomputeNext : Function = function() : void {
					{
						var $e : enum = (unfolder(_progress));
						switch( $e.index ) {
						case 0:
						{
							_progress = null;
							_next = stx.Option.None;
						}
						break;
						case 1:
						var tuple : stx.Tuple2 = $e.params[0];
						{
							_progress = tuple._1;
							_next = stx.Option.Some(tuple._2);
						}
						break;
						}
					}
				}
				precomputeNext();
				return { hasNext : function() : Boolean {
					return !stx.Options.isEmpty(_next);
				}, next : function() : * {
					var n : * = stx.Options.get(_next);
					precomputeNext();
					return n;
				}}
			}}
		}
		
		static public function error(msg : String,pos : * = null) : * {
			throw "" + msg + " at " + Std.string(pos);
			return null;
		}
		
	}
}
