package stx.arw;

using stx.Tuples;

using stx.arw.Arrows;

import stx.Prelude;
import stx.Tuples.*;

typedef AAIn<I,O> 			= Tuple2<Arrow<I,O>,I>;
typedef ArrowApply<I,O> = Arrow<AAIn<I,O>,O>;

abstract ApplicationArrow<I,O>(ArrowApply<I,O>) from ArrowApply<I,O> to ArrowApply<I,O>{
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
	static public function over<I,O>(i:I):Arrow<Arrow<I,O>,O>{
		return function(arrow:Arrow<I,O>){
			return new ApplicationArrow().apply(tuple2(arrow,i));
		}
	}
	static public function with<I,O>(a:Arrow<Arrow<I,O>,O>,b:Arrow<Arrow<I,O>,O>,fn:O->O->O):Arrow<Arrow<I,O>,O>{
		return a.split(b).then(fn.spread());
	}
	static public function mod<A,B,C,D>(a:Arrow<A,Tuple2<Arrow<B,C>,B>>,fn:C->D):Arrow<A,Tuple2<Arrow<B,D>,B>>{
		return a.then(
			function(t:Tuple2<Arrow<B,C>,B>):Tuple2<Arrow<B,D>,B>{
				return t.fst().then(fn).entuple(t.snd());
			}
		);
	}
}