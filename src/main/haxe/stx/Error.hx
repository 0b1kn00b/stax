package stx;

import haxe.CallStack;
import haxe.PosInfos;

using stx.Functions;

abstract Fails(Array<Error>) from Array<Error> to Array<Error>{
	@:from static public inline function fromError(e:Error){
		return new Fails([e]);
	}
	public function new(v){
		this = v;
	}
	public function messages(){
		return Arrays.map(this, function(x) return x.msg);
	}
	public var length(get,never):Int;
	private function get_length():Int{
		return this.length;
	}
}
class Error{
	public static var exception(get_exception, null):Future<Error>;
	private static function get_exception() {
		if (exception == null) { exception = new Future(); }
		return exception;
	}
	public var pos(default,null)	: PosInfos;
	public var msg(default,null) 	: String;
	public var cde(default,null) 	: String;

	public function new(msg:String,?pos:PosInfos,?cde:String) {
		this.msg 				= msg;
		this.pos 				= pos;
		this.cde 				= cde;
	}
	public function except(){
		exception.deliver( this );
		return this;
	}
	public function toString():String{
		return "ERROR:\t(" + this.msg + " at " + Positions.toString(pos) + ")";
	}
	public function equals(e:Error){
		return cde = e.cde;
	}
	@:noUsing public static function create(msg:String,?pos:PosInfos){
		return new Error(msg, pos);
	}
	@:noUsing static public function build(?pos:PosInfos):String->Error{
		return toError.p2(pos);
	}
	static public function toError(msg:String,?pos:PosInfos){
		return Error.create(msg,pos);
	}
	static public function err(message:String,?pos:PosInfos){
		return new Error(message,pos);
	}
	static public inline function asError<E:Error>(e:E):Error{
		return e;
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