package stx.arw;

import stx.arw.Arrows;
import stx.Prelude;

using stx.arw.RepeatArrow;
class RepeatArrow <I, O > implements Arrow < I , O > {
	var a : Arrow < I, FreeM< I, O > > ;
	public function new < A > (a : Arrow < I, FreeM < I, O > > ) {
		this.a = a;
	}
	inline public function withInput(?i : I, cont : Function1<O,Void>) : Void {
		var thiz = this;
		function withRes(res : FreeM < I, O > ) {
			switch (res) {
				case Cont(rv): thiz.a.withInput(rv, cast withRes#if (flash || js).trampoline()#end); //  break this recursion!
				case Done(dv): cont(dv);
			}
		}
		a.withInput(i, withRes);
	}
	#if !(neko || php || cpp )
	static public function trampoline<I>(f:I->Void){
		return 
			function(x:I):Void{
				haxe.Timer.delay( 
					function() { 
						f(x);
					},10
				);
			}
	}
	#end
}