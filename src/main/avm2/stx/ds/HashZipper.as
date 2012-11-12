package stx.ds {
	import stx.Tuples;
	import stx.ds.Zipper;
	import stx.Tuple2;
	public class HashZipper {
		static public function key(z : stx.ds.Zipper,field : String) : stx.ds.Zipper {
			var f : Function = function(x : Hash) : stx.Tuple2 {
				return stx.Tuples.t2(field,x.get(field));
			}
			return z.map(f);
		}
		
		static public function spawn(z : stx.ds.Zipper) : Array {
			var obj : Hash = z.get();
			return Prelude.SArrays.map(Prelude.SIterables.toArray(Prelude.SIterables.toIterable(obj.keys())),function() : Function {
				var $r : Function;
				var _e : stx.ds.Zipper = z;
				$r = function(field : String) : stx.ds.Zipper {
					return stx.ds.HashZipper.key(_e,field);
				}
				return $r;
			}());
		}
		
	}
}
