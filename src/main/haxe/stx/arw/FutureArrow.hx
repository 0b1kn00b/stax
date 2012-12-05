package stx.arw;

import stx.Prelude;

using stx.arw.Arrows;

class FutureArrow<O> implements Arrow<Future<O>,O>{
	public function new(){

	}
	inline public function withInput(?i:Future<O>,cont:Function<O,Void>){
		i.foreach( cont );
	}
	static public function arrowOf<I,O>(fn:I->Future<O>):Arrow<I,O>{
		return fn.lift().then( Arrows.future() );
	}
}