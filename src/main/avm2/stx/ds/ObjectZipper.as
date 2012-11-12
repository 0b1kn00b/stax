package stx.ds {
	import stx.Tuples;
	import stx.ds.Zipper;
	import stx.Tuple2;
	public class ObjectZipper {
		static public function field(z : stx.ds.Zipper,field : String) : stx.ds.Zipper {
			var f : Function = function(x : *) : stx.Tuple2 {
				return stx.Tuples.t2(field,Reflect.field(x,field));
			}
			return z.map(f);
		}
		
		static public function spawn(z : stx.ds.Zipper) : Array {
			var obj : * = z.get();
			return Prelude.SArrays.map(Reflect.fields(obj),function() : Function {
				var $r : Function;
				var _e : stx.ds.Zipper = z;
				$r = function(field : String) : * {
					return Reflect.field(_e,field);
				}
				return $r;
			}());
		}
		
	}
}
