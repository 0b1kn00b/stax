package stx.math;

using Std;
using Type;

typedef TRange = {
	min 	: Float,
	max 	: Float
}
abstract Range(TRange) from TRange to TRange {
	public static var MIN 	= -1.7976931348623157 * Math.pow(10,308);
	public static var MAX 	=  1.7976931348623157 * Math.pow(10,308);

	@:noUsing static public function create(?min ,?max){
		if(min == null){
			min = MIN;
		}
		if(max == null){
			max = MAX;
		}
		return new Range( { min : min, max : max } );
	}

	public var min(get_min,never):Float;
	private function get_min(){
		return this.min;
	}
	public var max(get_max,never):T;
	private function get_max(){
		return this.max;
	}
	public function new(?trange:TRange<Dynamic>){
		if(trange!=null){
			this = trange;
		}else{
			this = {
				min : MIN,
				max : MAX
			}
		}
	}
	public function equals(v1:Range):Bool {
		return (this.min == v1.min) && (this.max == v1.max);
	}
	public function overlap(v1:Range):Bool {
		return this.max > v1.min && v1.max > this.min;
	}
	public function within(n:T):Bool {
		return n > this.min && n < this.max;
	}
	public function inside(v1:Range<Dynamic>):Bool{
		return this.min > v1.min && this.max < v1.max;
	}
	public function delta<A>():Float{
		return this.max - this.min;
	}
	public function toString(){
		return 'stx.ds.Range(min:$min,max:$max)';
	}
}