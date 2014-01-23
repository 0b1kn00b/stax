package stx.async.arrowlet;

using stx.Tuples;
import Prelude;

using stx.async.Arrowlet;
import stx.async.arrowlet.PairArrowlet;

abstract Split<A,B,C>(Arrowlet<A,Tuple2<B,C>>){
	public function new(l,r){
    this = inline 
	}
}