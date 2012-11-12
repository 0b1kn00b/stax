package stx.error {
	import flash.Boot;
	import stx.error._Error;
	public class AssertionError extends stx.error._Error {
		public function AssertionError(msg : String = null,pos : * = null) : void { if( !flash.Boot.skip_constructor ) {
			super(msg,pos);
		}}
		
	}
}
