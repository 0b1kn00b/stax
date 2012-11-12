package stx {
	import stx.Method;
	import stx.Tuple2;
	import stx.error.OutOfBoundsError;
	import flash.Boot;
	public class Method2 extends stx.Method {
		public function Method2(fn : Function = null,name : String = null,pos : * = null) : void { if( !flash.Boot.skip_constructor ) {
			super(fn,name,pos);
		}}
		
		public override function replaceAt(i : int,v : *) : stx.Method {
			if(i > 1) throw new stx.error.OutOfBoundsError({ fileName : "Methods.hx", lineNumber : 157, className : "stx.Method2", methodName : "replaceAt"});
			else switch(i) {
			case 0:
			this.args._1 = v;
			break;
			case 1:
			this.args._2 = v;
			break;
			}
			return this;
		}
		
		public override function patch(_tmp_args : *) : stx.Method {
			var args : stx.Tuple2 = _tmp_args;
			this.args = stx.Tuple2.patch(this.args,args);
			return this;
		}
		
		public override function execute(_tmp_v : * = null,pos : * = null) : * {
			var v : stx.Tuple2 = _tmp_v;
			{
				var $e : enum = (this.convention);
				switch( $e.index ) {
				case 1:
				v = stx.Tuple2.patch(this.args,v);
				break;
				case 2:
				v = this.args;
				break;
				default:
				break;
				}
			}
			return this.fn(v._1,v._2);
		}
		
		public override function get_length() : int {
			return 2;
		}
		
		static public function toMethod(v : Function,name : String) : stx.Method2 {
			return new stx.Method2(v,name,{ fileName : "Methods.hx", lineNumber : 170, className : "stx.Method2", methodName : "toMethod"});
		}
		
	}
}
