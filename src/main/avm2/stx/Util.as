package stx {
	import haxe.Log;
	public class Util {
		static public function printer(value : *,pos : * = null) : * {
			haxe.Log._trace(value,{ fileName : "Util.hx", lineNumber : 4, className : "stx.Util", methodName : "printer", customParams : [pos]});
			return value;
		}
		
	}
}
