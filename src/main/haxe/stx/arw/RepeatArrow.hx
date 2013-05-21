package stx.arw;

import stx.Prelude;

using stx.arw.Arrows;
using stx.arw.RepeatArrow;
using stx.Compose;

abstract RepeatArrow<I,O>(Arrow<I,O>) to Arrow<I,O> from Arrow<I,O>{
	public function new(a:Arrow<I,FreeM<I,O>>) {
		this = new Arrow(
			inline function(?i : I, cont : O->Void) : Void {
				function withRes(res : FreeM < I, O > ) {
					switch (res) {
						case Cont(rv): a.withInput(rv, cast withRes#if (flash || js).trampoline()#end); //  break this recursion!
						case Done(dv): cont(dv);
					}
				}
				a.withInput(i, withRes);
			}
		);
	}
	public function apply(v:I){
		return this.apply(v);
	}
}
class RepeatArrows{
	#if !(neko || php || cpp )
	static public function trampoline<I>(f:I->Void){
		return function(x:I):Void{
				haxe.Timer.delay( 
					function() { 
						f(x);
					},10
				);
			}
	}
	#end
}