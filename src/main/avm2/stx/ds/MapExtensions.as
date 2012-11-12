package stx.ds {
	import stx.ds.Map;
	import stx.Tuple2;
	public class MapExtensions {
		static public function toObject(map : stx.ds.Map) : * {
			return map.foldl({ },function(object : *,tuple : stx.Tuple2) : * {
				Reflect.setField(object,tuple._1,tuple._2);
				return object;
			});
		}
		
		static public function toMap(d : *) : stx.ds.Map {
			var map : stx.ds.Map = stx.ds.Map.create();
			{
				var _g : int = 0, _g1 : Array = Reflect.fields(d);
				while(_g < _g1.length) {
					var field : String = _g1[_g];
					++_g;
					var value : * = Reflect.field(d,field);
					map = map.set(field,value);
				}
			}
			return map;
		}
		
	}
}
