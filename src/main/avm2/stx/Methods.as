package stx {
	import stx.Method;
	import stx.Option;
	import stx.Options;
	public class Methods {
		static public function apply(f : stx.Option,v : *,pos : * = null) : * {
			return function() : * {
				var $r : *;
				{
					var $e2 : enum = (f);
					switch( $e2.index ) {
					case 1:
					var f1 : stx.Method = $e2.params[0];
					$r = f1.execute(v,pos);
					break;
					case 0:
					$r = null;
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function applyOr(o : stx.Option,x : *,f0 : Function,pos : * = null) : stx.Option {
			return function() : stx.Option {
				var $r : stx.Option;
				{
					var $e2 : enum = (o);
					switch( $e2.index ) {
					case 1:
					var f : stx.Method = $e2.params[0];
					$r = stx.Options.toOption(f.execute(x,pos));
					break;
					case 0:
					$r = function() : stx.Option {
						var $r3 : stx.Option;
						f0();
						$r3 = stx.Option.None;
						return $r3;
					}();
					break;
					}
				}
				return $r;
			}();
		}
		
	}
}
