package stx.arw;

import stx.Tuples;
import stx.Prelude;
import stx.arw.Arrows;

class SplitArrow<A,B,C> implements Arrow<A,Tuple2<B,C>>{
	var a : PairArrow<A,B,A,C>;
	public function new(l,r){
		this.a = new PairArrow(l,r);
	}
	inline public function withInput(?i : A, cont : Function1< Tuple2<B,C> , Void > ) : Void{
		a.withInput( Tuples.t2(i,i) , cont);
	}
}