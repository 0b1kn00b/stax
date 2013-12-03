package stx.arrowlet;

import Prelude;

using stx.Arrowlet;
using stx.arrowlet.Repeat;
using stx.Compose;

abstract Repeat<I,O>(Arrowlet<I,O>) to Arrowlet<I,O> from Arrowlet<I,O>{
	public function new(a: Arrowlet<I,Free<I,O>>) {
		this = new Arrowlet(
			inline function(?i : I, cont : O->Void) : Void {
				function withRes(res: Free<I, O> ) {
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
class Repeats{
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