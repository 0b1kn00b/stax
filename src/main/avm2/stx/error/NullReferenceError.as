package stx.error {
	import flash.Boot;
	import stx.error._Error;
	public class NullReferenceError extends stx.error._Error {
		public function NullReferenceError(fieldname : String = null,pos : * = null) : void { if( !flash.Boot.skip_constructor ) {
			super(stx.error._Error.printf([fieldname]," \"${0}\" is null"),pos);
		}}
		
	}
}
