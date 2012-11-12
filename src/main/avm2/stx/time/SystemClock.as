package stx.time {
	import stx.time.Clock;
	public class SystemClock implements stx.time.Clock{
		public function SystemClock() : void {
		}
		
		public function now() : Date {
			return Date["now"]();
		}
		
	}
}
