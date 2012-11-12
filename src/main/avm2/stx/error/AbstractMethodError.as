package stx.error {
	import flash.Boot;
	import stx.error._Error;
	public class AbstractMethodError extends stx.error._Error {
		public function AbstractMethodError(pos : * = null) : void { if( !flash.Boot.skip_constructor ) {
			super("Called abstract method",pos);
		}}
		
	}
}
