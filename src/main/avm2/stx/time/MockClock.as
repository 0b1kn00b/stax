package stx.time {
	import stx.time.Clock;
	import flash.Boot;
	public class MockClock implements stx.time.Clock{
		public function MockClock() : void { if( !flash.Boot.skip_constructor ) {
			this.time = 0.0;
		}}
		
		public function now() : Date {
			return Date["fromTime"](this.time);
		}
		
		public var time : Number;
	}
}
