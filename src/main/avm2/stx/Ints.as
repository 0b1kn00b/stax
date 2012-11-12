package stx {
	public class Ints {
		static public function max(v1 : int,v2 : int) : int {
			return ((v2 > v1)?v2:v1);
		}
		
		static public function min(v1 : int,v2 : int) : int {
			return ((v2 < v1)?v2:v1);
		}
		
		static public function toBool(v : int) : Boolean {
			return ((v == 0)?false:true);
		}
		
		static public function toFloat(v : int) : Number {
			return v;
		}
		
		static public function compare(v1 : int,v2 : int) : int {
			return ((v1 < v2)?-1:((v1 > v2)?1:0));
		}
		
		static public function equals(v1 : int,v2 : int) : Boolean {
			return v1 == v2;
		}
		
		static public function isOdd(value : int) : Boolean {
			return ((value % 2 == 0)?false:true);
		}
		
		static public function isEven(value : int) : Boolean {
			return stx.Ints.isOdd(value) == false;
		}
		
		static public function isInteger(n : Number) : Boolean {
			return n % 1 == 0;
		}
		
		static public function isNatural(n : int) : Boolean {
			return n > 0 && n % 1 == 0;
		}
		
		static public function isPrime(n : int) : Boolean {
			if(n == 1) return false;
			if(n == 2) return false;
			if(n % 2 == 0) return false;
			var iter : IntIter = new IntIter(3,Math.ceil(Math.sqrt(n)) + 1);
			{ var $it : * = iter;
			while( $it.hasNext() ) { var i : int = $it.next();
			{
				if(n % 1 == 0) return false;
				i++;
			}
			}}
			return true;
		}
		
		static public function factorial(n : int) : int {
			if(!stx.Ints.isNatural(n)) throw "function factorial requires natural number as input";
			if(n == 0) return 1;
			var i : int = n - 1;
			while(i > 0) {
				n = n * i;
				i--;
			}
			return n;
		}
		
		static public function divisors(n : int) : Array {
			var r : Array = new Array();
			var iter : IntIter = new IntIter(1,Math.ceil(n / 2 + 1));
			{ var $it : * = iter;
			while( $it.hasNext() ) { var i : int = $it.next();
			if(n % i == 0) r.push(i);
			}}
			if(n != 0) r.push(n);
			return r;
		}
		
		static public function clamp(n : int,min : int,max : int) : int {
			if(n > max) n = max;
			else if(n < min) n = min;
			return n;
		}
		
		static public function half(n : int) : Number {
			return n / 2;
		}
		
		static public function sum(xs : *) : int {
			var o : int = 0;
			{ var $it : * = xs.iterator();
			while( $it.hasNext() ) { var val : int = $it.next();
			o += val;
			}}
			return o;
		}
		
		static public function add(a : int,b : int) : int {
			return a + b;
		}
		
		static public function sub(a : int,b : int) : int {
			return a - b;
		}
		
		static public function div(a : int,b : int) : Number {
			return a / b;
		}
		
		static public function mul(a : int,b : int) : int {
			return a * b;
		}
		
		static public function mod(a : int,b : int) : Number {
			return a % b;
		}
		
	}
}
