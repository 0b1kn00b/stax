class SplitArrow<A,B,C> implements Arrow<A,Pair<B,C>>{
	var a : PairArrow<A,B,A,C>;
	public function new(l,r){
		this.a = new PairArrow(l,r);
	}
	inline public function withInput(?i : A, cont : Function1< Pair<B,C> , Void > ) : Void{
		a.withInput( Tuples.t2(i,i) , cont);
	}
}