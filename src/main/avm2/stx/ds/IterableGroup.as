package stx.ds {
	import stx.ds.ArrayGroup;
	import stx.ds.Map;
	public class IterableGroup {
		static public function groupBy(iter : *,grouper : Function) : stx.ds.Map {
			return stx.ds.ArrayGroup.groupBy(Prelude.SIterables.toArray(iter),grouper);
		}
		
	}
}
