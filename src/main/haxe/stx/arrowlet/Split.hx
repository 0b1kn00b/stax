package stx.arrowlet;

using stx.Tuples;
import Prelude;

using stx.Arrowlet;
import stx.arrowlet.PairArrowlet;

abstract Split<A,B,C>(Arrowlet<A,Tuple2<B,C>>){
	public function new(l,r){
    this = inline 
	}
}