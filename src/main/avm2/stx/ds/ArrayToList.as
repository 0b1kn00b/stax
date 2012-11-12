package stx.ds {
	import stx.ds.List;
	public class ArrayToList {
		static public function toList(arr : Array) : stx.ds.List {
			return stx.ds.List.create().addAll(arr);
		}
		
	}
}
