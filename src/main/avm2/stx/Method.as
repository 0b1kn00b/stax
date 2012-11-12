package stx {
	import stx.error.AbstractMethodError;
	import stx.MethodConvention;
	import stx.Log;
	import haxe.Log;
	import flash.Boot;
	public class Method {
		public function Method(fn : * = null,name : String = null,pos : * = null) : void { if( !flash.Boot.skip_constructor ) {
			this.pos = pos;
			this.name = name;
			if(fn == null) haxe.Log._trace(stx.Log.warning("Setting null function"),{ fileName : "Methods.hx", lineNumber : 52, className : "stx.Method", methodName : "new"});
			this.convention = stx.MethodConvention.Patch;
			this.fn = fn;
		}}
		
		public function toString() : String {
			return "Method " + this.name + "[ " + Std.string(this.pos) + " ]";
		}
		
		public function isEmpty() : Boolean {
			return this.fn == null;
		}
		
		public function requals(f : *) : Boolean {
			return Reflect.compareMethods(this.fn,f);
		}
		
		public function equals(m : stx.Method) : Boolean {
			return Reflect.compareMethods(this.fn,m.fn);
		}
		
		public function replaceAt(i : int,v : *) : stx.Method {
			throw new stx.error.AbstractMethodError({ fileName : "Methods.hx", lineNumber : 66, className : "stx.Method", methodName : "replaceAt"});
			return null;
		}
		
		public function patch(args : *) : stx.Method {
			throw new stx.error.AbstractMethodError({ fileName : "Methods.hx", lineNumber : 62, className : "stx.Method", methodName : "patch"});
			return null;
		}
		
		public function execute(v : * = null,pos : * = null) : * {
			if(this.isEmpty()) throw new stx.error.AbstractMethodError({ fileName : "Methods.hx", lineNumber : 58, className : "stx.Method", methodName : "execute"});
			return null;
		}
		
		public function get_length() : int {
			throw new stx.error.AbstractMethodError({ fileName : "Methods.hx", lineNumber : 45, className : "stx.Method", methodName : "get_length"});
			return -1;
		}
		
		public function get length() : int { return get_length(); }
		protected function set length( __v : int ) : void { $length = __v; }
		protected var $length : int;
		public var args : *;
		public var fn : *;
		public var convention : stx.MethodConvention;
		public function setName(n : String) : stx.Method {
			this.name = n;
			return this;
		}
		
		public var name : String;
		public var pos : *;
	}
}
