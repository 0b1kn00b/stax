package stx.arrowlet;

using stx.Tuples;

using stx.Arrowlet;

import Prelude;
import stx.Tuples;

typedef AAIn<I,O> 			= Tuple2<Arrowlet<I,O>,I>;
typedef TApply<I,O> 		= Arrowlet<AAIn<I,O>,O>;

abstract Apply<I,O>(TApply<I,O>) from TApply<I,O> to TApply<I,O>{
	static public inline function app(){
	  return new Apply();
	}
	public function new(){
		this = new Arrowlet(
			inline function(i:Tuple2<Arrowlet<I,O>,I>,cont: O->Void){
				i.fst().withInput(
					i.snd(),
						function(x){
							cont(x);
						}
				);
			}
		);
	}
}		