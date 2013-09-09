package stx.arw;

import stx.Prelude;

using stx.Arrows;

abstract ThenArrow<I,O,NO>(Arrow<I, NO>) from Arrow<I, NO> to Arrow<I, NO>{
	public function new(a:Arrow<I,O>,b:Arrow<O,NO>){
		var _a : Arrow<I,O> 	= a;
		var _b : Arrow<O,NO> 	= b;
		this = new Arrow(
			inline function(i : I, cont : Function1<NO,Void>) : Void {
				var m  = function (reta : O) { _b.withInput(reta, cont);};
				_a.withInput(i, m);
			}
		);
	}
}