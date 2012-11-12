package stx.reactive {
	import flash.Boot;
	public class Pulse {
		public function Pulse(stamp : int = 0,value : * = null) : void { if( !flash.Boot.skip_constructor ) {
			this.stamp = stamp;
			this.value = value;
			var elements : Array = [];
			elements.push(stamp);
			elements.push(value);
		}}
		
		public function withValue(newValue : *) : stx.reactive.Pulse {
			return new stx.reactive.Pulse(this.stamp,newValue);
		}
		
		public function map(f : Function) : stx.reactive.Pulse {
			return this.withValue(f(this.value));
		}
		
		public var value : *;
		public var stamp : int;
	}
}
