package stx.err;
import haxe.PosInfos;

import haxe.PosInfos;

class AbstractMethodError extends Error {
	
	public function new(?pos:PosInfos) {
		super( "called abstract method", pos );
	}
}