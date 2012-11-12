package stx {
	import stx.Method;
	import stx.error.AbstractMethodError;
	import haxe.Log;
	import stx.error.OutOfBoundsError;
	import flash.Boot;
	public class Method1 extends stx.Method {
		public function Method1(fn : Function = null,name : String = null,pos : * = null) : void { if( !flash.Boot.skip_constructor ) {
			super(fn,name,pos);
		}}
		
		public override function replaceAt(i : int,v : *) : stx.Method {
			if(i != 0) throw new stx.error.OutOfBoundsError({ fileName : "Methods.hx", lineNumber : 128, className : "stx.Method1", methodName : "replaceAt"});
			this.args = v;
			return this;
		}
		
		public override function patch(_tmp_args : *) : stx.Method {
			var args : * = _tmp_args;
			this.args = args;
			return this;
		}
		
		public override function execute(_tmp_v : * = null,pos : * = null) : * {
			var v : * = _tmp_v;
			if(this.fn == null || this.isEmpty()) throw new stx.error.AbstractMethodError({ fileName : "Methods.hx", lineNumber : 104, className : "stx.Method1", methodName : "execute"});
			var o : * = null;
			try {
				o = (function($this:Method1) : * {
					var $r : *;
					{
						var $e2 : enum = ($this.convention);
						switch( $e2.index ) {
						case 0:
						case 1:
						$r = $this.fn(v);
						break;
						case 2:
						$r = $this.fn($this.args);
						break;
						}
					}
					return $r;
				}(this));
			}
			catch( e : * ){
				haxe.Log._trace("Declared " + Std.string(this) + " \n called " + Std.string(e),{ fileName : "Methods.hx", lineNumber : 114, className : "stx.Method1", methodName : "execute"});
			}
			return o;
		}
		
		public override function get_length() : int {
			return 1;
		}
		
		static public function toMethod(v : Function,name : String,pos : * = null) : stx.Method1 {
			return new stx.Method1(v,name,pos);
		}
		
	}
}
