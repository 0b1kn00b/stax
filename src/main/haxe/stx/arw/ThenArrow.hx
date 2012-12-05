package stx.arw;

import stx.Prelude;
import stx.arw.Arrows;

class ThenArrow< I, O, NO > extends Arrow<I, NO> {
	var a : Arrow < I, O >;
	var b : Arrow < O, NO >;
	public function new (a : Arrow < I, O > , b : Arrow < O, NO > ) {
		super();
		this.a = a;
		this.b = b;
	}
	override inline public function withInput(?i : I, cont : Function1<NO,Void>) : Void {
		var m  = function (reta : O) { this.b.withInput(reta, cont);};
		a.withInput(i, m);
	}
}