package stx.ds {
	import stx.Functions1;
	import stx.ds.Input;
	import stx.Functions2;
	import stx.ds.IterV;
	import stx.reactive.Stream;
	public class IterVs {
		static public function run(iter : stx.ds.IterV) : * {
			{
				var $e : enum = (iter);
				switch( $e.index ) {
				case 0:
				var a : * = $e.params[0];
				return a;
				break;
				case 1:
				throw "Computation not finished";
				break;
				}
			}
			return null;
		}
		
		static public function drop(n : int) : stx.ds.IterV {
			var step : Function = null;
			step = function(i : stx.ds.Input) : stx.ds.IterV {
				return function() : stx.ds.IterV {
					var $r : stx.ds.IterV;
					{
						var $e2 : enum = (i);
						switch( $e2.index ) {
						case 0:
						var e : * = $e2.params[0];
						$r = stx.ds.IterVs.drop(n - 1);
						break;
						case 1:
						$r = stx.ds.IterV.Cont(step);
						break;
						case 2:
						$r = stx.ds.IterV.Done(null,stx.ds.Input.EOF);
						break;
						}
					}
					return $r;
				}();
			}
			return ((n == 0)?stx.ds.IterV.Done(null,stx.ds.Input.Empty):stx.ds.IterV.Cont(step));
		}
		
		static public function pump(s : stx.reactive.Stream,iter : stx.ds.IterV) : stx.reactive.Stream {
			return s.scanl(iter,function(it : stx.ds.IterV,x : stx.ds.Input) : stx.ds.IterV {
				return function() : stx.ds.IterV {
					var $r : stx.ds.IterV;
					{
						var $e2 : enum = (it);
						switch( $e2.index ) {
						case 0:
						var e : stx.ds.Input = $e2.params[1], a : * = $e2.params[0];
						$r = stx.ds.IterV.Done(a,e);
						break;
						case 1:
						var k : Function = $e2.params[0];
						$r = k(x);
						break;
						}
					}
					return $r;
				}();
			});
		}
		
		static public function flatMap(f1 : stx.ds.IterV,f2 : Function) : stx.ds.IterV {
			return function() : stx.ds.IterV {
				var $r : stx.ds.IterV;
				{
					var $e2 : enum = (f1);
					switch( $e2.index ) {
					case 0:
					var e : stx.ds.Input = $e2.params[1], x : * = $e2.params[0];
					$r = function() : stx.ds.IterV {
						var $r3 : stx.ds.IterV;
						{
							var $e4 : enum = (f2(x));
							switch( $e4.index ) {
							case 0:
							var y : * = $e4.params[0];
							$r3 = stx.ds.IterV.Done(y,e);
							break;
							case 1:
							var k : Function = $e4.params[0];
							$r3 = k(e);
							break;
							}
						}
						return $r3;
					}();
					break;
					case 1:
					var k1 : Function = $e2.params[0];
					$r = stx.ds.IterV.Cont(stx.Functions1.andThen(k1,stx.Functions2.p2(stx.ds.IterVs.flatMap,f2)));
					break;
					}
				}
				return $r;
			}();
		}
		
	}
}
