package stx {
	import stx.Method;
	import flash.Boot;
	public class Method0 extends stx.Method {
		public function Method0(fn : Function = null,name : String = null,pos : * = null) : void { if( !flash.Boot.skip_constructor ) {
			super(fn,name,pos);
		}}
		
		public override function execute(_tmp_v : * = null,pos : * = null) : * {
			var v : void = _tmp_v;
			super.execute(null,{ fileName : "Methods.hx", lineNumber : 88, className : "stx.Method0", methodName : "execute"});
			return this.fn();
		}
		
		static public function toMethod(fn : Function,name : String) : stx.Method0 {
			return new stx.Method0(fn,name,{ fileName : "Methods.hx", lineNumber : 92, className : "stx.Method0", methodName : "toMethod"});
		}
		
	}
}
