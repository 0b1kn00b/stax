interface IArrow<I,O>{
	public function withInput(?i : I, cont : Function1<O,Void>) : Void;
}
class Arrow<I,O> implements IArrow<I,O>{
	public function new(){}
	public function withInput(?i : I, cont : Function1<O,Void> ) : Void{}

	static public function act<I>(fn:I->Void):Arrow<I,I>{
		return 
			function(x){
				fn(x);
				return x;
			}.lift();
	}
	static public function both<A,B>(a:Arrow<A,B>):Arrow<Tuple2<A,A>,Tuple2<B,B>>{
		return a.pair(a);
	}
	static public function compose<A,B,C>(a0:Arrow<B,C>,a1:Arrow<A,B>){
		return a1.then(a0);
	}
}