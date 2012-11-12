package stx.ds {
	import stx.Tuples;
	import stx.ds.Zipper;
	import stx.Tuple2;
	public class ArrayZipper {
		static public function index(z : stx.ds.Zipper,index : int) : stx.ds.Zipper {
			var f : Function = function(x : Array) : stx.Tuple2 {
				return stx.Tuples.t2(index,x[index]);
			}
			return z.map(f);
		}
		
		static public function spawn(z : stx.ds.Zipper) : Array {
			var obj : Array = z.get();
			return Prelude.SArrays.map(Prelude.SIterables.toArray(IntIters.until(0,obj.length)),function() : Function {
				var $r : Function;
				var _e : stx.ds.Zipper = z;
				$r = function(index : int) : stx.ds.Zipper {
					return stx.ds.ArrayZipper.index(_e,index);
				}
				return $r;
			}());
		}
		
	}
}
