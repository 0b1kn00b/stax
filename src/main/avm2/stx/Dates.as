package stx {
	public class Dates {
		static public function compare(v1 : Date,v2 : Date) : int {
			var diff : Number = v1.getTime() - v2.getTime();
			return ((diff < 0)?-1:((diff > 0)?1:0));
		}
		
		static public function equals(v1 : Date,v2 : Date) : Boolean {
			return v1.getTime() == v2.getTime();
		}
		
		static public function toString(v : Date) : String {
			return v["toStringHX"]();
		}
		
	}
}
