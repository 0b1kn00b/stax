package stx.ds {
	import stx.ds.List;
	import stx.functional.Foldable;
	public class FoldableToList {
		static public function toList(foldable : stx.functional.Foldable) : stx.ds.List {
			var dest : stx.ds.List = stx.ds.List.create();
			return foldable.foldl(dest,function(a : stx.ds.List,b : *) : stx.ds.List {
				return a.append(b);
			});
		}
		
	}
}
