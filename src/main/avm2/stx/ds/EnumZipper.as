package stx.ds {
	import stx.ds.Zipper;
	public class EnumZipper {
		static public function param(z : stx.ds.Zipper,index : int) : stx.ds.Zipper {
			var n : * = Type.enumParameters(z.current)[index];
			var f : Function = function(x : enum) : * {
				return Type.enumParameters(x)[index];
			}
			return z.map(f);
		}
		
	}
}
