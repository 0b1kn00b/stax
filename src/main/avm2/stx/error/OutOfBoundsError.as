package stx.error {
	import flash.Boot;
	import stx.error._Error;
	public class OutOfBoundsError extends stx.error._Error {
		public function OutOfBoundsError(pos : * = null) : void { if( !flash.Boot.skip_constructor ) {
			super("Index out of bounds at " + Std.string(pos),pos);
		}}
		
	}
}
