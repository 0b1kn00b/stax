package stx.ds {
	import stx.ds.Input;
	import stx.ds.IterV;
	import stx.ds.LList;
	public class Examples {
		static public function enumerate() : Function {
			return function(arr : stx.ds.LList,it : stx.ds.IterV) : stx.ds.IterV {
				{
					var $e : enum = (arr);
					switch( $e.index ) {
					case 1:
					{
						{
							var $e2 : enum = (it);
							switch( $e2.index ) {
							case 0:
							return it;
							break;
							case 1:
							var k : Function = $e2.params[0];
							return k(stx.ds.Input.EOF);
							break;
							}
						}
						return it;
					}
					break;
					case 0:
					var rest : stx.ds.LList = $e.params[1], e : * = $e.params[0];
					{
						{
							var $e3 : enum = (it);
							switch( $e3.index ) {
							case 0:
							return it;
							break;
							case 1:
							var k1 : Function = $e3.params[0];
							return (stx.ds.Examples.enumerate())(rest,k1(stx.ds.Input.El(e)));
							break;
							}
						}
					}
					break;
					}
				}
				return null;
			}
		}
		
		static public function counter() : stx.ds.IterV {
			return function() : stx.ds.IterV {
				var $r : stx.ds.IterV;
				var step : Function = function() : Function {
					var $r2 : Function;
					var step1 : Function = null;
					step1 = function(n : int) : Function {
						return function(inp : stx.ds.Input) : stx.ds.IterV {
							return function() : stx.ds.IterV {
								var $r3 : stx.ds.IterV;
								{
									var $e4 : enum = (inp);
									switch( $e4.index ) {
									case 0:
									var x : * = $e4.params[0];
									$r3 = stx.ds.IterV.Cont(step1(n + 1));
									break;
									case 1:
									$r3 = stx.ds.IterV.Cont(step1(n));
									break;
									case 2:
									$r3 = stx.ds.IterV.Done(n,stx.ds.Input.EOF);
									break;
									}
								}
								return $r3;
							}();
						}
					}
					$r2 = step1;
					return $r2;
				}();
				$r = stx.ds.IterV.Cont(step(0));
				return $r;
			}();
		}
		
	}
}
