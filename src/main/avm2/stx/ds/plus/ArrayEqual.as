package stx.plus {
	import stx.plus.Equal;
	public class ArrayEqual {
		static public function equals(v1 : Array,v2 : Array) : Boolean {
			return stx.plus.ArrayEqual.equalsWith(v1,v2,stx.plus.Equal.getEqualFor(v1[0]));
		}
		
		static public function equalsWith(v1 : Array,v2 : Array,equal : Function) : Boolean {
			if(v1.length != v2.length) return false;
			if(v1.length == 0) return true;
			{
				var _g1 : int = 0, _g : int = v1.length;
				while(_g1 < _g) {
					var i : int = _g1++;
					if(!equal(v1[i],v2[i])) return false;
				}
			}
			return true;
		}
		
	}
}
