package  {
	import haxe.Log;
	import flash.Boot;
	public class AllClasses {
		public function AllClasses() : void { if( !flash.Boot.skip_constructor ) {
			haxe.Log._trace("This is a generated main class",{ fileName : "AllClasses.hx", lineNumber : 154, className : "AllClasses", methodName : "new"});
		}}
		
		static public var __meta__ : * = { obj : { IgnoreCover : null}, statics : { main : { IgnoreCover : null}}, fields : { _ : { IgnoreCover : null}}}
		static public function main() : AllClasses {
			return new AllClasses();
		}
		
	}
}
