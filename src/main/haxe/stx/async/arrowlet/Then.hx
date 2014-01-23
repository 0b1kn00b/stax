package stx.async.arrowlet;

import Prelude;

using stx.async.Arrowlet;

abstract Then<I,O,NO>(Arrowlet<I, NO>) from Arrowlet<I, NO> to Arrowlet<I, NO>{
	public function new(a: Arrowlet<I, O>,b: Arrowlet<O, NO>){
		var _a : Arrowlet<I,O> 	= a;
		var _b : Arrowlet<O,NO> 	= b;
		this = new Arrowlet(
			inline function(i: I, cont: NO->Void): Void {
				var m  = function (reta : O) { _b.withInput(reta, cont);};
				_a.withInput(i, m);
			}
		);
	}
}