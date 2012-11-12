package stx.error {
	import stx.error.Positions;
	import stx.Future;
	import flash.Boot;
	public class _Error {
		public function _Error(msg : String = null,pos : * = null) : void { if( !flash.Boot.skip_constructor ) {
			this.msg = msg;
			this.pos = pos;
		}}
		
		public function toString() : String {
			return "Error: (" + this.msg + " at " + stx.error.Positions.toString(this.pos) + ")";
		}
		
		public function except() : stx.error._Error {
			stx.error._Error.get_exception().deliver(this,{ fileName : "Error.hx", lineNumber : 27, className : "stx.Error", methodName : "except"});
			return this;
		}
		
		protected var pos : *;
		protected var msg : String;
		static public function get exception() : stx.Future { return get_exception(); }
		protected function set exception( __v : stx.Future ) : void { $exception = __v; }
		static protected var $exception : stx.Future;
		static public function get_exception() : stx.Future {
			if(stx.error._Error.$exception == null) stx.error._Error.exception = new stx.Future();
			return stx.error._Error.$exception;
		}
		
		static public function toError(msg : String,pos : * = null) : stx.error._Error {
			return new stx.error._Error(msg,pos);
		}
		
		static public function printf(a : Array,str : String) : String {
			var out : String = "";
			var reg : EReg = new EReg("(\\$\\{[0-9]\\})+","");
			var ms : String = str;
			var lst : String = "";
			while(true) try {
				reg.match(ms);
				var match : String = reg.matched(0);
				out += reg.matchedLeft();
				var index : * = Std._parseInt(match.charAt(2));
				out += Std.string(a[index]);
				ms = reg.matchedRight();
			}
			catch( e : * ){
				break;
			}
			out += ms;
			return out;
		}
		
	}
}
