package haxe.macro {
	import flash.Boot;
	public class _Error {
		public function _Error(m : String = null,p : * = null) : void { if( !flash.Boot.skip_constructor ) {
			this.message = m;
			this.pos = p;
		}}
		
		public var pos : *;
		public var message : String;
	}
}
