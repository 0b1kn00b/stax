package stx.arw;

using stx.Tuples;

using stx.Arrows;

import stx.Prelude;
import stx.Tuples;

typedef AAIn<I,O> 			= Tuple2<Arrow<I,O>,I>;
typedef ArrowApply<I,O> = Arrow<AAIn<I,O>,O>;

abstract ApplyArrow<I,O>(ArrowApply<I,O>) from ArrowApply<I,O> to ArrowApply<I,O>{
	static public inline function app(){
	  return new ApplyArrow();
	}
	public function new(){
		this = new Arrow(
			inline function(i:Tuple2<Arrow<I,O>,I>,cont : Function1<O,Void>){
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