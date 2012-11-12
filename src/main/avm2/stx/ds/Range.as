package stx.ds {
	import flash.Boot;
	public class Range {
		public function Range(trange : * = null) : void { if( !flash.Boot.skip_constructor ) {
			if(trange != null) {
				this.min = trange.min;
				this.max = trange.max;
			}
			else {
				this.min = stx.ds.Range.MIN;
				this.max = stx.ds.Range.MAX;
			}
		}}
		
		public function toString() : String {
			var tname : String = Type.getClassName(Type.getClass(this));
			return "" + tname + "(min:" + Std.string(this.min) + ",max:" + Std.string(this.max) + ")";
		}
		
		public function delta() : * {
			return this.max - this.min;
		}
		
		public function inside(v1 : stx.ds.Range) : Boolean {
			return this.min > v1.min && this.max < v1.max;
		}
		
		public function within(n : *) : Boolean {
			return n > this.min && n < this.max;
		}
		
		public function overlap(v1 : stx.ds.Range) : Boolean {
			return this.max > v1.min && v1.max > this.min;
		}
		
		public function equals(v1 : stx.ds.Range) : Boolean {
			return this.min == v1.min && this.max == v1.max;
		}
		
		public var max : *;
		public var min : *;
		static public var MIN : Number = -1.7976931348623157 * Math.pow(10,308);
		static public var MAX : Number = 1.7976931348623157 * Math.pow(10,308);
		static public function create(min : * = null,max : * = null) : stx.ds.Range {
			if(min == null) min = stx.ds.Range.MIN;
			if(max == null) max = stx.ds.Range.MAX;
			return new stx.ds.Range({ min : min, max : max});
		}
		
	}
}
