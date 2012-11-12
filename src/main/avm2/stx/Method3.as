package stx {
	import stx.Tuple3;
	import stx.Method;
	import stx.error.OutOfBoundsError;
	import flash.Boot;
	public class Method3 extends stx.Method {
		public function Method3(fn : Function = null,name : String = null,pos : * = null) : void { if( !flash.Boot.skip_constructor ) {
			super(fn,name,pos);
		}}
		
		public override function replaceAt(i : int,v : *) : stx.Method {
			if(i > 2) throw new stx.error.OutOfBoundsError({ fileName : "Methods.hx", lineNumber : 198, className : "stx.Method3", methodName : "replaceAt"});
			else switch(i) {
			case 0:
			this.args._1 = v;
			break;
			case 1:
			this.args._2 = v;
			break;
			case 2:
			this.args._3 = v;
			break;
			}
			return this;
		}
		
		public override function patch(_tmp_args : *) : stx.Method {
			var args : stx.Tuple3 = _tmp_args;
			this.args = stx.Tuple3.patch(this.args,args);
			return this;
		}
		
		public override function execute(_tmp_v : * = null,pos : * = null) : * {
			var v : stx.Tuple3 = _tmp_v;
			{
				var $e : enum = (this.convention);
				switch( $e.index ) {
				case 1:
				v = stx.Tuple3.patch(this.args,v);
				break;
				case 2:
				v = this.args;
				break;
				default:
				break;
				}
			}
			return this.fn(v._1,v._2,v._3);
		}
		
		public override function get_length() : int {
			return 3;
		}
		
		static public function toMethod(v : Function,name : String) : stx.Method3 {
			return new stx.Method3(v,name,{ fileName : "Methods.hx", lineNumber : 212, className : "stx.Method3", methodName : "toMethod"});
		}
		
	}
}
