package stx.math.tween {
	import stx.ds.ArrayToSet;
	import stx.ds.Set;
	import stx.ds.Map;
	import stx.Options;
	import stx.Tuple2;
	import stx.functional.Foldables;
	import stx.Entuple;
	import stx.ds.FoldableToMap;
	public class Tween {
		static public function linear(state1 : *,state2 : *,def : * = 0.0) : Function {
			if(def==null) def=0.0;
			var combinedFields : stx.ds.Set = stx.ds.ArrayToSet.toSet(Reflect.fields(state1)).addAll(Reflect.fields(state2));
			var data : stx.ds.Map = stx.ds.FoldableToMap.toMap(stx.functional.FoldableExtensions.map(combinedFields,function(name : String) : stx.Tuple2 {
				var start : Number = stx.Options.getOrElseC(stx.Options.toOption(Reflect.field(state1,name)),def);
				var end : Number = stx.Options.getOrElseC(stx.Options.toOption(Reflect.field(state2,name)),def);
				return stx.Entuple.entuple(name,{ start : start, delta : end - start});
			}));
			return function(t : Number) : * {
				return data.foldl({ },function(r : *,tuple : stx.Tuple2) : * {
					var name1 : String = tuple._1;
					var start1 : Number = tuple._2.start;
					var delta : Number = tuple._2.delta;
					Reflect.setField(r,name1,start1 + t * delta);
					return r;
				});
			}
		}
		
	}
}
