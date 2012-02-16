package stax.error;
import haxe.Stack;

/**
 * ...
 * @author 0b1kn00b
 */

class Error {

	var msg : String;
		
	public function new(msg:String) {
		this.msg = msg;
	}
	public function toString():String{
		return "ERROR: " + this.msg;
	}
}