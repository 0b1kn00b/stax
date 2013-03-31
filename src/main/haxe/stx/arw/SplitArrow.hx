package stx.arw;

using stx.Tuples;
import stx.Prelude;

import stx.arw.Arrows;
import stx.arw.PairArrow;

abstract SplitArrow<A,B,C>(Arrow<A,Tup2<B,C>>){
	public function new(l,r){
    this = new Arrow(
      inline function(?i:A, cont:Tuple2<B,C>->Void) : Void{
        var  a : ArrowPair<A,B,A,C> = new PairArrow(l,r);
        return a.withInput( Tuples.t2(i,i) , cont);
      });
	}
  public function apply(?i:A){
    return this.apply(i);
  }
  public function rep():Arrow<A,Tup2<B,C>>{
    return this;
  }
}