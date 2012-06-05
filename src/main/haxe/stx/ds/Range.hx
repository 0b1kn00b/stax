package stx.ds;

class Range<T:Float> {
	public static var MIN 	= -1.7976931348623157 * Math.pow(10,308);
	public static var MAX 	=  1.7976931348623157 * Math.pow(10,308);

	public var min(default,null):T;
	public var max(default,null):T;

	@:bug('#0b1kn00b: why do I need to cast here')
	public function new(?trange:TRange<Dynamic>){
		if(trange!=null){
			this.min = cast trange.min;
			this.max = cast trange.max;
		}else{
			this.min = cast MIN;
			this.max = cast MAX;
		}
	}
	public function equals(v1:Range<Dynamic>):Bool {
		return (min == v1.min) && (max == v1.max);
	}
	public function overlap(v1:Range<Dynamic>):Bool {
		return max > v1.min && v1.max > min;
	}
	public function within(n:T):Bool {
		return n > min && n < max;
	}
	public function inside(v1:Range<Dynamic>):Bool{
		return min > v1.min && max < v1.max;
	}
	public function delta<A>():T{
		return max - min;
	}
	public static function create(?min,?max){
		return new Range( { min : min, max : max } );
	}
	//public static function apply<A,B>(r:Range<A>,f0 : Range<A> -> B,):B{
		//return f0(r);
	//}
}
typedef TRange<T:Float> = {
	min 	: Float,
	max 	: Float
}