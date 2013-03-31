package stx.arw;

using stx.Tuples;

using stx.arw.Arrows;

import stx.Prelude;

typedef AAIn<I,O> 			= Tuple2<Arrow<I,O>,I>
typedef ArrowApply<I,O> = Arrow<AAIn<I,O>,O>;

abstract ApplyArrow<I,O>(ArrowApply<I,O>) from ArrowApply<I,O> to ArrowApply<I,O>{
	public function new(){
		this = new Arrow(
			inline function(?i:Tuple2<Arrow<I,O>,I>,cont : Function1<O,Void>){
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
			return new ApplyArrow().apply(Tuples.t2(arrow,i));
		}.arrowOf();
	}
	static public function with<I,O>(a:Arrow<Arrow<I,O>,O>,b:Arrow<Arrow<I,O>,O>,fn:O->O->O):Arrow<Arrow<I,O>,O>{
		return a.split(b).then(fn.spread().lift());
	}
	static public function mod<A,B,C,D>(a:Arrow<A,Tuple2<Arrow<B,C>,B>>,fn:C->D):Arrow<A,Tuple2<Arrow<B,D>,B>>{
		return a.then(
			function(t:Tuple2<Arrow<B,C>,B>):Tuple2<Arrow<B,D>,B>{
				return t.fst().then(fn.lift()).entuple(t.snd());
			}.lift()
		);
	}
	public function apply(?i){
    return this.apply(i);
  }
  public function rep(){
  	return this;
  }
}