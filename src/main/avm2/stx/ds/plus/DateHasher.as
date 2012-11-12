package stx.plus {
	public class DateHasher {
		static public function hashCode(v : Date) : int {
			return Math.round(v.getTime() * 49157);
		}
		
	}
}
