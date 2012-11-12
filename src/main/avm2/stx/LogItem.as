package stx {
	import stx.LogLevel;
	import flash.Boot;
	public class LogItem {
		public function LogItem(level : stx.LogLevel = null,value : * = null) : void { if( !flash.Boot.skip_constructor ) {
			this.level = level;
			this.value = value;
		}}
		
		public var value : *;
		public var level : stx.LogLevel;
		public function toString() : String {
			return Std.string(this.level) + "[ " + Std.string(this.value) + " ]";
		}
		
	}
}
