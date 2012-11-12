package stx.reactive {
	public class Rank {
		static protected var _rank : int = 0;
		static public function lastRank() : int {
			return stx.reactive.Rank._rank;
		}
		
		static public function nextRank() : int {
			return ++stx.reactive.Rank._rank;
		}
		
	}
}
