package stx.arw;

import stx.Prelude;

class RepeatArrow <I, O > implements Arrow < I , O > {
	var a : Arrow < I, FreeM< I, O > > ;
	public function new < A > (a : Arrow < I, Either < I, O > > ) {
		this.a = a;
	}
	inline public function withInput(?i : I, cont : Function1<O,Void>) : Void {
		var thiz = this;
		function withRes(res : Either < I, O > ) {
			switch (res) {
				case Left(rv): thiz.a.withInput(rv, cast withRes#if (flash || js).trampoline()#end); //  break this recursion!
				case Right(dv): cont(dv);
			}
		}
		a.withInput(i, withRes);
	}
}