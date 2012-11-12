package stx.plus {
	import stx.plus.Show;
	public class ArrayShow {
		static public function toString(v : Array) : String {
			return stx.plus.ArrayShow.toStringWith(v,stx.plus.Show.getShowFor(v[0]));
		}
		
		static public function toStringWith(v : Array,show : Function) : String {
			return "[" + Prelude.SArrays.map(v,show).join(", ") + "]";
		}
		
		static public function mkString(arr : Array,sep : String = ", ",show : Function = null) : String {
			if(sep==null) sep=", ";
			var isFirst : Boolean = true;
			return Prelude.SArrays.foldl(arr,"",function(a : String,b : *) : String {
				var prefix : String = ((isFirst)?function() : String {
					var $r : String;
					isFirst = false;
					$r = "";
					return $r;
				}():sep);
				if(null == show) show = stx.plus.Show.getShowFor(b);
				return a + prefix + show(b);
			});
		}
		
	}
}
