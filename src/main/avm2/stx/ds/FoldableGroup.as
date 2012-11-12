package stx.ds {
	import stx.ds.Map;
	import stx.functional.Foldable;
	public class FoldableGroup {
		static public function groupBy(foldable : stx.functional.Foldable,grouper : Function) : stx.ds.Map {
			var def : stx.functional.Foldable = foldable.empty();
			return foldable.foldl(stx.ds.Map.create(),function(map : stx.ds.Map,e : *) : stx.ds.Map {
				var key : * = grouper(e);
				var result : stx.functional.Foldable = map.getOrElseC(key,def);
				return map.set(key,result.append(e));
			});
		}
		
	}
}
