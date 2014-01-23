package stx.mcr;

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Type;

class Macros{
	macro static public function typeOf(expr:Expr){
    return expr;		
	}
}