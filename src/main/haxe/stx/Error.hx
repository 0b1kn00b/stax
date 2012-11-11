package stx;

import haxe.Stack;
import haxe.PosInfos;

using stx.Functions;

class Error {

	public static var exception(get_exception, null):Future<Error>;
	private static function get_exception() {
		if (exception == null) { exception = new Future(); }
		return exception;
	}
	
	var msg : String;
	public var pos(default,null)	: PosInfos;
	
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
	@:noUsing
	public static function create(msg:String,?pos:PosInfos){
		return new Error(msg, pos);
	}
	static public function toError(msg:String,?pos:PosInfos){
		return Error.create(msg,pos);
	}
	@:noUsing
	static public function build(?pos:PosInfos):String->Error{
		return toError.p2(pos);
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