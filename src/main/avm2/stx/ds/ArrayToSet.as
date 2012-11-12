package stx.ds {
	import stx.ds.Set;
	public class ArrayToSet {
		static public function toSet(arr : Array) : stx.ds.Set {
			return stx.ds.Set.create().addAll(arr);
		}
		
	}
}
