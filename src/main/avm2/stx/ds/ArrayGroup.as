package stx.ds {
	import stx.ds.Map;
	public class ArrayGroup {
		static public function groupBy(arr : Array,grouper : Function) : stx.ds.Map {
			return Prelude.SArrays.foldl(arr,stx.ds.Map.create(),function(map : stx.ds.Map,e : *) : stx.ds.Map {
				var key : * = grouper(e);
				var result : Array = map.getOrElse(key,function() : Array {
					return [];
				});
				result.push(e);
				return map.set(key,result);
			});
		}
		
	}
}
