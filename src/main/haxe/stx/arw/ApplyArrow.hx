typedef ArrowApplyT<I,O> = Arrow<Pair<Arrow<I,O>,I>,O>;
class ApplyArrow<I,O> implements Arrow<Pair<Arrow<I,O>,I>,O>{
	public function new(){
	}
	inline public function withInput(?i:Pair<Arrow<I,O>,I>,cont : Function1<O,Void>){
		i._1.withInput(
			i._2,
				function(x){
					cont(x);
				}
		);
	}
}