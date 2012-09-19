package stx.error;
import haxe.PosInfos;

import haxe.PosInfos;

class AbstractMethodError extends Error {
	
	public function new(?pos:PosInfos) {
		super( "Called abstract method", pos );
	}
}