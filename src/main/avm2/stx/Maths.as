package stx {
	public class Maths {
		static public function rndOne(weight : * = 0.5) : int {
			if(weight==null) weight=0.5;
			return Std._int(Math.random() - weight);
		}
		
		static public function radians(v : Number) : Number {
			return v * (Math.PI / 180);
		}
		
		static public function degrees(v : Number) : Number {
			return v * (180 / Math.PI);
		}
		
	}
}
