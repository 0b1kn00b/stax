package stx.reactive {
	public class Stamp {
		static protected var _stamp : int = 1;
		static public function lastStamp() : int {
			return stx.reactive.Stamp._stamp;
		}
		
		static public function nextStamp() : int {
			return ++stx.reactive.Stamp._stamp;
		}
		
	}
}
