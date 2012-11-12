package stx.ds {
	import stx.ds.Map;
	public class ArrayToMap {
		static public function toMap(arr : Array) : stx.ds.Map {
			return stx.ds.Map.create().addAll(arr);
		}
		
	}
}
