package stx;

using stx.Maths;

class Maths {	
	static var PRIMES : Array<Int> = [1, 3, 7, 13, 31, 61, 127, 251, 509, 1021, 2039, 4093, 8191, 16381, 32749, 65521, 131071, 262139, 524287, 1048573, 2097143, 4194301, 8388593, 16777213, 33554393, 67108859, 134217689, 268435399, 536870909, 1073741789, 2147483647];
	@doc("Produces either a zero or a one randomly, influenced by `weight`")
	static public inline function rndOne(?weight : Float = 0.5 ):Int {
		return Std.int ( ( Math.random() - weight )  );
	}
	@doc("Produces the radians of a given angle in degrees.")
	static public inline function radians(v:Float) {
		return v * ( Math.PI / 180 );
	}
	@doc("Produces the degrees of a given angle in radians.")
	static public inline function degrees(v:Float) {
		return v * ( 180 / Math.PI ) ;
	}
	@:noUsing static public inline function random(max = 1,min = 0){
		return Math.random() * (max - min) + min;
	}
}
class Floats {
	@doc("Produces the difference between `n1` and `n0`.")
	static public inline function delta(n0:Float,n1:Float){
		return n1 - n0;
	}
	@doc("Produces `v` mapped between `n0` and `n1` and scaled to a value between 0 and 1.")
	static public inline function normalize(v:Float,n0:Float,n1:Float){
		return (v - n0) / delta(n0, n1);
	}
	@doc("Produces a value between `n0` and `n1` where `v` specifies the distance between the two with a number between 0 and 1.")
	static public inline function interpolate(v:Float,n0:Float,n1:Float){
		return n0 + ( delta(n0, n1) ) * v;
	}
	@doc("Take a value `v` as a value on the number line `min0` to `min1` and produce a value on the number line `min1` to `max1`")
	static public inline function map(v:Float,min0:Float,max0:Float,min1:Float,max1:Float){
		return interpolate(normalize(v, min0, max0), min1, max1);
	}
	@doc("Round `n` to `c` decimal places.")
	static public inline function round(n:Float,c:Int = 1):Int{
		var r = Math.pow(10, c);
		return (Math.round(n * r) / r).int();
	}
	@doc("Ceiling `n` to `c` decimal places.")
	static public inline function ceil(n:Float,c:Int = 1):Int{
		var r = Math.pow(10, c);
		return (Math.ceil(n * r) / r).int();
	}
	@doc("Floor `n` to `c` decimal places.")
	static public inline function floor(n:Float,c:Int = 1):Int{
		var r = Math.pow(10, c);
		return (Math.floor(n * r) / r).int();
	}
	@doc(
		"Produce a number based on `n` that is `min` if less than `min`, 
		`max` if `n` is greater than `max` and is left untouched if
		between the two."
	)  
	static public inline function clamp(n:Float, min : Float , max : Float) {
		if (n > max) { n = max; }else if (n < min) { n = min; }
		return n;
	}
	
	@doc("Produce -1 if `n` is less than 0, 1 if `n` is greater, and 0 if input is 0.")
	static public inline function sgn(n:Float) {
		return (n == 0 ? 0 : Math.abs(n) / n);
	}

	@doc("Produce the larger of `v1` and `v2`.")
  static public function max(v1: Float, v2: Float): Float { return if (v2 > v1) v2; else v1; }

  @doc("Produce the smaller of `v1` and `v2`.")
  static public function min(v1: Float, v2: Float): Float { return if (v2 < v1) v2; else v1; }

  @doc("Alias for Std.int")
  static public function int(v: Float): Int { return Std.int(v); } 

  @doc("Produce 1 if `v1` is greater, -1 if `v2` is greater and 0 if `v1` and `v2` are equal.")
  static public function compare(v1: Float, v2: Float) {   
    return if (v1 < v2) -1 else if (v1 > v2) 1 else 0;
  }
  @doc("Produce `true`if `v1` and `v2` are eaual, `false` otherwise.")
  static public function equals(v1: Float, v2: Float) {
    return v1 == v2;
  }
  @doc("Produce String of Float.")
  static public function toString(v: Float): String {
    return "" + v;
  }
  @doc("Produce Int of Float.")
  static public function toInt(v: Float): Int {
    return Std.int(v);
  }
  @doc("Add two Floats.")
  static public inline function add(a:Float,b:Float):Float{
		return a + b;
	}
	@doc("Subtract `b` from `a`.")
	static public inline function sub(a:Float,b:Float):Float{
		return a - b;
	}
	@doc("Divide `a` by `b`.")
	static public inline function div(a:Float,b:Float):Float{
		return a / b;
	}
	@doc("Multiply `a` by `b`.")
	static public inline function mul(a:Float,b:Float):Float{
		return a * b;
	}
	@doc("Mod `a` by `b`.")
	static public inline function mod(a:Float,b:Float):Float{
		return a % b;
	}
}
class Ints {
	static public inline var ZERO : Int = 0;
	static public inline var ONE  : Int = 1;
	@doc("Produces whichever is the greater.")
	static public inline function max(v1: Int, v2: Int): Int { return if (v2 > v1) v2; else v1; }
	@doc("Produces whichever is the lesser.")
  static public function min(v1: Int, v2: Int): Int { return if (v2 < v1) v2; else v1; }
	@doc("Produces a Bool if 'v' == 0;")
  static public function toBool(v: Int): Bool { return if (v == 0) false else true; }
	@doc("Coerces an Int to a Float.")
  static public function toFloat(v: Int): Float { return v; }
    
	@doc("Produces -1 if `v1` is smaller, 1 if `v1` is greater, or 0 if `v1 == v2`")
  static public function compare(v1: Int, v2: Int) : Int {
    return if (v1 < v2) -1 else if (v1 > v2) 1 else 0;
  }
	@doc("Produces true if `v1` == `v2`")
  static public function equals(v1: Int, v2: Int) : Bool {
    return v1 == v2;
  }
	@doc("Produces true if `n` is odd, false otherwise.")
	static public inline function isOdd(n:Int) {
		return n%2 == 0 ? false : true;
	}
	@doc("Produces true if `n` is even, false otherwise.")
	static public inline function isEven(n:Int){
		return (isOdd(n) == false);
	}
	@doc("Produces true if `n` is an integer, false otherwise.")
	static public inline function isInteger(n:Float){
		return (n%1 == 0);
	}
	@doc("Produces true if `n` is a natural number, false otherwise.")
	static public inline function isNatural(n:Int){
		return ((n > 0) && (n%1 == 0));
	}
	@doc("Produces true if `n` is a prime number, false otherwise.")
	static public inline function isPrime(n:Int){
		if (n == 1) return false;
		if (n == 2) return false;
		if (n%2== 0) return false;
		var itr = new IntIterator(3,Math.ceil(Math.sqrt(n))+1);
		for (i in itr){
			if (n % 1 == 0){
				return false;
			}
			i++;
		}
		return true;
	}
	@doc("Produces the factorial of `n`.")
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
	@doc("Produces the values that n can divide into")
	static public inline function divisors(n:Int){
		var r = new Array<Int>();
		var iter = new IntIterator(1,Math.ceil((n/2)+1));
		for (i in iter){
			if (n % i == 0){
				r.push(i);
			}
		}
		if (n!=0){r.push(n);}
		return r;
	}
	@doc("Produces a value between `min` and `max`")
	static public inline function clamp(n:Int, min : Int , max : Int  ) {
		if (n > max) {
			n = max;
		}else if ( n < min) {
			n = min;
		}
		return n;
	}
	@doc("Produces half of `n`.")
	static public inline function half(n:Int) {
		return n / 2;
	}
	@doc("Produces the sum of the elements in `xs`.")
	static public inline function sum(xs:Iterable<Int>):Int {
		var o = 0;
		for ( val in xs ) {
			o += val;
		}
		return o;
	}
	@doc("Add two Ints.")
	static public inline function add(a:Int,b:Int):Int{
		return a + b;
	}
	@doc("Subtracts `b` from `a`.")
	static public inline function sub(a:Int,b:Int):Int{
		return a - b;
	}
	@doc("Divides `a` by `b`.")
	static public inline function div(a:Int,b:Int):Float{
		return a / b;
	}
	@doc("Multiplies `a` by `b`")
	static public inline function mul(a:Int,b:Int):Int{
		return a * b;
	}
	@doc("Mod `a` by `b`")
	static public inline function mod(a:Int,b:Int):Int{
		return a % b;
	}
	static public inline function inv(n:Int):Int{
		return -n;
	}
	static public inline function and(a : Int, b : Int) : Int{
		return a & b;
	}
	@doc("Returns true if `a == b`")
	static public inline function eq(a:Int, b:Int) : Bool{
		return (a == b);
	}
	@doc("Returns true if `a > b`")
	static public inline function gt(a:Int, b:Int){
		return (a > b);
	}
	@doc("Returns true if `a >= b`")
	static public inline function gteq(a:Int, b:Int){
		return (a >= b);
	}
	@doc("Returns true if `a < b`")
	static public inline function lt(a:Int, b:Int) : Bool{
		return (a < b);
	}
	@doc("Returns true if `a <= b`")
	static public inline function lteq(a:Int, b:Int){
		return (a <= b);
	}
	@doc("Returns `v >>> bits` (unsigned shift)")
	static public inline function ushr(v : Int, bits:Int) : Int{
		return v >>> bits;
	}
	@doc("Returns `a ^ b`")
	static public inline function xor(a : Int, b : Int) : Int{
		return a ^ b;
	}
	@doc("Returns `v << bits`")
	public static inline function shl(v : Int, bits:Int) : Int{
		return v << bits;
	}
	@doc("Returns `v >> bits` (signed shift)")
	public static inline function shr(v : Int, bits:Int) : Int{
		return v >> bits;
	}
	static public inline function abs(v : Int) : Int{
		return Std.int(Math.abs(v));
	}
	static public inline function toString(a:Int):String{
		return '$a';
	}
}