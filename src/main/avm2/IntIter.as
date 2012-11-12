package  {
	import flash.Boot;
	public class IntIter {
		public function IntIter(min : int = 0,max : int = 0) : void { if( !flash.Boot.skip_constructor ) {
			this.min = min;
			this.max = max;
		}}
		
		public function next() : int {
			return this.min++;
		}
		
		public function hasNext() : Boolean {
			return this.min < this.max;
		}
		
		protected var max : int;
		protected var min : int;
	}
}
