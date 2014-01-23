package stx.async.arrowlet;

import hx.ifs.Scheduler;

import stx.ioc.Inject.*;

import Prelude;

using stx.Tuples;
using stx.async.Arrowlet;
using stx.async.arrowlet.Repeat;
using stx.Compose;

typedef RepeatType<I,O> = Arrowlet<I,Free<I,O>>;

abstract Repeat<I,O>(Arrowlet<I,O>) to Arrowlet<I,O> from Arrowlet<I,O> to Arrowlet<I,O>{
	public function new(rpt:RepeatType<I,O>) {
		this = new Arrowlet(
			inline function(?i : I, cont : O->Void) : Void {
				function withRes(res: Free<I, O> ) {
					switch (res) {
						case Cont(rv): rpt.withInput(rv, cast withRes#if (flash || js).trampoline()#end); //  break this recursion!
						case Done(dv): cont(dv);
					}
				}
				rpt.withInput(i, withRes);
			}
		);
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

	static public function collect<I,O,Z>(arw:Arrowlet<I,O>,selector:O->Bool,fold:Z->O->Z,init:Z):Arrowlet<I,Z>{
		var op = init;
		return arw.tie(
			function(i:I,o:O){
				return switch (selector(o)) {
					case true 	: op = fold(op,o); 		Cont(i);
					case false  : 										Done(op);
				}
			}.tupled()
		).repeat();
	}
}