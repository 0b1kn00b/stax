package stx;

											using stx.Maths;
class Maths {	
	/**
	  Produces either a zero or a one randomly, influenced by ´weight´
	  @return
	 */
	static public inline function rndOne(?weight : Float = 0.5 ):Int {
		return Std.int ( ( Math.random() - weight )  );
	}
	/**
	  Produces the radians of a given angle in degrees.
	  @param	v
	 */
	static public inline function radians(v:Float) {
		return v * ( Math.PI / 180 );
	}
	/**
	  Produces the degrees of a given angle in radians.
	  @param	v
	 */
	static public inline function degrees(v:Float) {
		return v * ( 180 / Math.PI ) ;
	}
}
class Ints {
	/**
	  Produces whichever is the greater.
	  @param	v1
	  @param	v2
	  @return
	 */
	static public inline function max(v1: Int, v2: Int): Int { return if (v2 > v1) v2; else v1; }
	/**
	  Produces whichever is the lesser.
	  @param	v1
	  @param	v2
	  @return
	 */
  static public function min(v1: Int, v2: Int): Int { return if (v2 < v1) v2; else v1; }
	/**
	  Produces a Bool if 'v' == 0;
	  @param	v
	  @return
	 */
  static public function toBool(v: Int): Bool { return if (v == 0) false else true; }
	/**
	  Coerces an Int to a Float.
	  @param	v
	  @return
	 */
  static public function toFloat(v: Int): Float { return v; }
    
	/**
	  Produces -1 if 'v1' is smaller, 1 if 'v1' is greater, or 0 if 'v1' == 'v2'
	  @param	v1
	  @param	v2
	  @return
	 */
  static public function compare(v1: Int, v2: Int) : Int {
    return if (v1 < v2) -1 else if (v1 > v2) 1 else 0;
  }
	/**
	  Produces true if 'v1' == 'v2'
	  @param	v1
	  @param	v2
	  @return
	 */
  static public function equals(v1: Int, v2: Int) : Bool {
    return v1 == v2;
  }
	/**
	  Produces true if 'value' is odd, false otherwise.
	  @param	value
	 */
	static public inline function isOdd(value:Int) {
		return value%2 == 0 ? false : true;
	}
	/**
	  Produces true if 'value' is even, false otherwise.
	  @param	value
	 */
	static public inline function isEven(value:Int){
		return (isOdd(value) == false);
	}
	/**
	  Produces true if 'n' is an integer, false otherwise.
	  @param	n
	 */
	static public inline function isInteger(n:Float){
		return (n%1 == 0);
	}
	/**
	  Produces true if 'n' is a natural number, false otherwise.
	  @param	n
	 */
	static public inline function isNatural(n:Int){
		return ((n > 0) && (n%1 == 0));
	}
	/**
	  Produces true if 'n' is a prime number, false otherwise.
	  @param	n
	 */
	static public inline function isPrime(n:Int){
		if (n == 1) return false;
		if (n == 2) return false;
		if (n%2== 0) return false;
		var itr = new IntIter(3,Math.ceil(Math.sqrt(n))+1);
		for (i in itr){
			if (n % 1 == 0){
				return false;
			}
			i++;
		}
		return true;
	}
	/**
	  Produces the factorial of 'n'.
	  @param	n
	 */
	static public function factorial(n:Int){
		if (!isNatural(n)){
			throw "function factorial requires natural number as input";
		}
		if (n == 0){
			return 1;
		}
		var i = n-1;
		while(i>0){
			n = n*i;
			i--;
		}
		return n;
	}
	/**
		Produces the values that n can divide into
	*/
	static public inline function divisors(n:Int){
		var r = new Array<Int>();
		var iter = new IntIter(1,Math.ceil((n/2)+1));
		for (i in iter){
			if (n % i == 0){
				r.push(i);
			}
		}
		if (n!=0){r.push(n);}
		return r;
	}
	/**
		Produces a value between `min` and `max`
	*/
	static public inline function clamp(n:Int, min : Int , max : Int  ) {
		if (n > max) {
			n = max;
		}else if ( n < min) {
			n = min;
		}
		return n;
	}
	/**
	  Produces half of ´n´.
	  @param	n
	 */
	static public inline function half(n:Int) {
		return n / 2;
	}
	/**
	  Produces the sum of the elements in ´xs´.
	  @param	xs
	  @return
	 */
	static public inline function sum(xs:Iterable<Int>):Int {
		var o = 0;
		for ( val in xs ) {
			o += val;
		}
		return o;
	}
	/**
	 Add two Ints.
	*/
	static public inline function add(a:Int,b:Int):Int{
		return a + b;
	}
	/**
	 Subtracts ´b´ from ´a´.
	*/
	static public inline function sub(a:Int,b:Int):Int{
		return a - b;
	}
	/**
	 Divides ´a´ by ´b´.
	*/
	static public inline function div(a:Int,b:Int):Float{
		return a / b;
	}
	/**
	 Multiplies ´a´ by ´b´
	*/
	static public inline function mul(a:Int,b:Int):Int{
		return a * b;
	}
	/**
	 Mod ´a´ by ´b´
	*/
	static public inline function mod(a:Int,b:Int):Float{
		return a % b;
	}
}
class Floats {
	/**
	  Produces the difference between ´n1´ and ´n0´.
	  @param	n0
	  @param	n1
	 */
	static public inline function delta(n0:Float,n1:Float){
		return n1 - n0;
	}
	/**
		Produces ´v´ mapped between ´n0´ and ´n1´ and scaled to a value between 0 and 1.
	  @param	v
	  @param	n0
	  @param	n1
	 */
	static public inline function normalize(v:Float,n0:Float,n1:Float){
		return (v - n0) / delta(n0, n1);
	}
	/**
		Produces a value between ´n0´ and ´n1´ where ´v´ specifies the distance between the two
		with a number between 0 and 1.
	*/
	static public inline function interpolate(v:Float,n0:Float,n1:Float){
		return n0 + ( delta(n0, n1) ) * v;
	}
	/**
		Take a value ´v´ as a value on the number line ´min0´ to ´min1´ and produce
		a value on the number line ´min1´ to ´max1´
	*/
	static public inline function map(v:Float,min0:Float,max0:Float,min1:Float,max1:Float){
		return interpolate(normalize(v, min0, max0), min1, max1);
	}
	/**
		Round ´n´ to ´c´ decimal places
	*/
	static public inline function round(n:Float,c:Int = 1):Int{
		var r = Math.pow(10, c);
		return (Math.round(n * r) / r).int();
	}
	/**
		Ceiling ´n´ to ´c´ decimal places
	*/
	static public inline function ceil(n:Float,c:Int = 1):Int{
		var r = Math.pow(10, c);
		return (Math.ceil(n * r) / r).int();
	}
	/**
		Floor ´n´ to ´c´ decimal places
	*/
	static public inline function floor(n:Float,c:Int = 1):Int{
		var r = Math.pow(10, c);
		return (Math.floor(n * r) / r).int();
	}
	/**
		Produce a number based on ´n´ that is ´min´ if less than ´min´, 
		´max´ if ´n´ is greater than ´max´ and is left untouched if
		between the two.
	*/
	static public inline function clamp(n:Float, min : Float , max : Float) {
		if (n > max) { n = max; }else if (n < min) { n = min; }
		return n;
	}
	/**
		Produce -1 if ´n´ is less than 0, 1 if ´n´ is greater, and 0 if input is 0.
	*/
	static public inline function sgn(n:Float) {
		return (n == 0 ? 0 : Math.abs(n) / n);
	}
	/**
		Produce the larger of ´v1´ and ´v2´.
	*/
  static public function max(v1: Float, v2: Float): Float { return if (v2 > v1) v2; else v1; }
  /**
		Produce the smaller of ´v1´ and ´v2´.
	*/
  static public function min(v1: Float, v2: Float): Float { return if (v2 < v1) v2; else v1; }
  /**
		Alias for Std.int
	*/
  static public function int(v: Float): Int { return Std.int(v); } 
  /**
  	Produce 1 if ´v1´ is greater, -1 if ´v2´ is greater and 0 if ´v1´ and ´v2´ are equal.
  */
  static public function compare(v1: Float, v2: Float) {   
    return if (v1 < v2) -1 else if (v1 > v2) 1 else 0;
  }
  /**
  	Produce ´true´if ´v1´ and ´v2´ are eaual, ´false´ otherwise.
  */
  static public function equals(v1: Float, v2: Float) {
    return v1 == v2;
  }
  /**
  	Produce String of Float.
  */
  static public function toString(v: Float): String {
    return "" + v;
  }
  /**
	 Add two Floats.
	*/
  static public inline function add(a:Float,b:Float):Float{
		return a + b;
	}
	/**
	 Subtract ´b´ from ´a´
	*/
	static public inline function sub(a:Float,b:Float):Float{
		return a - b;
	}
	/**
		Divide ´a´ by ´b´.
	*/
	static public inline function div(a:Float,b:Float):Float{
		return a / b;
	}
	/**
		Multiply ´a´ by ´b´.
	*/
	static public inline function mul(a:Float,b:Float):Float{
		return a * b;
	}
	/**
		Mod ´a´ by ´b´.
	*/
	static public inline function mod(a:Float,b:Float):Float{
		return a % b;
	}
}