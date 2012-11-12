package stx.error {
	import flash.Boot;
	import stx.error._Error;
	public class IllegalOverrideError extends stx.error._Error {
		public function IllegalOverrideError(of : * = null,pos : * = null) : void { if( !flash.Boot.skip_constructor ) {
			super(stx.error._Error.printf([of],"Attempting illegal override of ${0}"),pos);
		}}
		
	}
}
