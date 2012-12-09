package stx.arw;

import stx.Prelude;

using stx.arw.Arrows;

class FutureArrow<O> implements Arrow<Future<O>,O>{
	public function new(){

	}
	inline public function withInput(?i:Future<O>,cont:Function<O,Void>){
		i.foreach( cont );
	}
}