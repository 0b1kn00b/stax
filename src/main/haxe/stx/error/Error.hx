package stx.error;

import haxe.Stack;
import haxe.PosInfos;

/**
 * ...
 * @author 0b1kn00b
 */

class Error {

	public static var exception(get_exception, null):Future<Error>;
	private static function get_exception() {
		if (exception == null) { exception = new Future(); }
		return exception;
	}
	
	var msg : String;
	var pos	: PosInfos;
	
	public function new(msg:String,?pos:PosInfos) {
		this.msg = msg;
		this.pos = pos;
	}
	public function except(){
		exception.deliver( this );
		return this;
	}
	public function toString():String{
		return "Error: (" + this.msg + " at " + Positions.toString(pos) + ")";
				
	}
	public static function toError(msg:String,?pos:PosInfos){
		return new Error(msg, pos);
	}

	public static function printf(a:Array<Dynamic>, str:String) {
		var out = '';
		var reg = new EReg('(\\$\\{[0-9]\\})+', '');
		var ms 	= str;
		var lst = '';
		while (true) {
			try {
				reg.match(ms);
				var match = reg.matched(0);
				out += reg.matchedLeft();
				var index = Std.parseInt( match.charAt(2) );
				out += Std.string( a[index] );
				ms = reg.matchedRight();
			}catch (e:Dynamic) {
				break;
			}
		}
		out += ms;
		return out;
	}
}
class Positions {
	public static function toString(pos:PosInfos){
		if (pos == null) return 'nil';
		var type                = pos.className.split(".");
		return type[type.length-1] + "::" + pos.methodName + "#" + pos.lineNumber;
	}
	public static function here(?pos:PosInfos) {
		return pos;
	}
}