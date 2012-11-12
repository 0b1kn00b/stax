package stx.ds {
	import stx.ds.Set;
	import stx.functional.Foldable;
	public class FoldableToSet {
		static public function toSet(foldable : stx.functional.Foldable) : stx.ds.Set {
			var dest : stx.ds.Set = stx.ds.Set.create();
			return foldable.foldl(dest,function(a : stx.ds.Set,b : *) : stx.ds.Set {
				return a.append(b);
			});
		}
		
	}
}
