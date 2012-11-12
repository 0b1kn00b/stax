package stx.ds {
	import stx.ds.Map;
	public class IterableToMap {
		static public function toMap(i : *) : stx.ds.Map {
			return stx.ds.Map.create().addAll(i);
		}
		
	}
}
