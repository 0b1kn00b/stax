package stx.arw;

import stx.Prelude;

using stx.arw.Arrows;

class FutureArrow<O> extends Arrow<Future<O>,O>{
	public function new(){
		super();
	}
	override inline public function withInput(?i:Future<O>,cont:Function<O,Void>):Void{
		i.foreach( cont );
	}
}