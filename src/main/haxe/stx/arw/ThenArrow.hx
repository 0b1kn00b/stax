package stx.arw;

class ThenArrow< I, O, NO > extends Arrow<I, NO> {
	var a : Arrow < I, O >;
	var b : Arrow < O, NO >;
	public function new (a : Arrow < I, O > , b : Arrow < O, NO > ) {
		this.a = a;
		this.b = b;
	}
	inline public function withInput(?i : I, cont : Function1<NO,Void>) : Void {
		var m  = function (reta : O) { this.b.withInput(reta, cont);};
		a.withInput(i, m);
	}
}