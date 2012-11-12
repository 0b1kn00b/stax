package stx {
	public class Floats {
		static public function delta(n0 : Number,n1 : Number) : Number {
			return n1 - n0;
		}
		
		static public function normalize(v : Number,n0 : Number,n1 : Number) : Number {
			return (v - n0) / stx.Floats.delta(n0,n1);
		}
		
		static public function interpolate(v : Number,n0 : Number,n1 : Number) : Number {
			return n0 + stx.Floats.delta(n0,n1) * v;
		}
		
		static public function map(v : Number,min0 : Number,max0 : Number,min1 : Number,max1 : Number) : Number {
			return stx.Floats.interpolate(stx.Floats.normalize(v,min0,max0),min1,max1);
		}
		
		static public function round(n : Number,c : int = 1) : int {
			var r : Number = Math.pow(10,c);
			return stx.Floats._int(Math.round(n * r) / r);
		}
		
		static public function ceil(n : Number,c : int = 1) : int {
			var r : Number = Math.pow(10,c);
			return stx.Floats._int(Math.ceil(n * r) / r);
		}
		
		static public function floor(n : Number,c : int = 1) : int {
			var r : Number = Math.pow(10,c);
			return stx.Floats._int(Math.floor(n * r) / r);
		}
		
		static public function clamp(n : Number,min : Number,max : Number) : Number {
			if(n > max) n = max;
			else if(n < min) n = min;
			return n;
		}
		
		static public function sgn(n : Number) : Number {
			return ((n == 0)?0:Math.abs(n) / n);
		}
		
		static public function max(v1 : Number,v2 : Number) : Number {
			return ((v2 > v1)?v2:v1);
		}
		
		static public function min(v1 : Number,v2 : Number) : Number {
			return ((v2 < v1)?v2:v1);
		}
		
		static public function _int(v : Number) : int {
			return Std._int(v);
		}
		
		static public function compare(v1 : Number,v2 : Number) : int {
			return ((v1 < v2)?-1:((v1 > v2)?1:0));
		}
		
		static public function equals(v1 : Number,v2 : Number) : Boolean {
			return v1 == v2;
		}
		
		static public function toString(v : Number) : String {
			return "" + v;
		}
		
		static public function add(a : Number,b : Number) : Number {
			return a + b;
		}
		
		static public function sub(a : Number,b : Number) : Number {
			return a - b;
		}
		
		static public function div(a : Number,b : Number) : Number {
			return a / b;
		}
		
		static public function mul(a : Number,b : Number) : Number {
			return a * b;
		}
		
		static public function mod(a : Number,b : Number) : Number {
			return a % b;
		}
		
	}
}
