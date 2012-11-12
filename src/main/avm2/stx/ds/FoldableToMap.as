package stx.ds {
	import stx.ds.Map;
	import stx.functional.Foldable;
	import stx.Tuple2;
	public class FoldableToMap {
		static public function toMap(foldable : stx.functional.Foldable) : stx.ds.Map {
			var dest : stx.ds.Map = stx.ds.Map.create();
			return foldable.foldl(dest,function(a : stx.ds.Map,b : stx.Tuple2) : stx.ds.Map {
				return a.append(b);
			});
		}
		
	}
}
