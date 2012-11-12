package stx {
	import stx.Functions2;
	import stx.Arrays;
	public class ArrayType {
		static public function find(a : Class) : Function {
			return stx.Functions2.flip(stx.Arrays.find);
		}
		
		static public function map(a : Class) : Function {
			return stx.Functions2.flip(Prelude.SArrays.map);
		}
		
	}
}
