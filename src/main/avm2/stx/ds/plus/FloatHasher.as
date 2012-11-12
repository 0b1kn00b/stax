package stx.plus {
	public class FloatHasher {
		static public function hashCode(v : Number) : int {
			return Std._int(v * 98317);
		}
		
	}
}
