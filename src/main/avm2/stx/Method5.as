package stx {
	import stx.Method;
	import stx.Tuple5;
	import stx.error.OutOfBoundsError;
	import flash.Boot;
	public class Method5 extends stx.Method {
		public function Method5(fn : Function = null,name : String = null,pos : * = null) : void { if( !flash.Boot.skip_constructor ) {
			super(fn,name,pos);
		}}
		
		public override function replaceAt(i : int,v : *) : stx.Method {
			if(i > 4) throw new stx.error.OutOfBoundsError({ fileName : "Methods.hx", lineNumber : 279, className : "stx.Method5", methodName : "replaceAt"});
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
			case 3:
			this.args._4 = v;
			break;
			case 4:
			this.args._5 = v;
			break;
			}
			this.args = v;
			return this;
		}
		
		public override function patch(_tmp_args : *) : stx.Method {
			var args : stx.Tuple5 = _tmp_args;
			this.args = stx.Tuple5.patch(this.args,args);
			return this;
		}
		
		public override function execute(_tmp_v : * = null,pos : * = null) : * {
			var v : stx.Tuple5 = _tmp_v;
			{
				var $e : enum = (this.convention);
				switch( $e.index ) {
				case 1:
				v = stx.Tuple5.patch(this.args,v);
				break;
				case 2:
				v = this.args;
				break;
				default:
				break;
				}
			}
			return this.fn(v._1,v._2,v._3,v._4,v._5);
		}
		
		public override function get_length() : int {
			return 5;
		}
		
		static public function toMethod(v : Function,name : String) : stx.Method5 {
			return new stx.Method5(v,name,{ fileName : "Methods.hx", lineNumber : 294, className : "stx.Method5", methodName : "toMethod"});
		}
		
	}
}
