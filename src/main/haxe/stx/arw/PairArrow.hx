package stx.arw;

import stx.Tuples;
import stx.Prelude;
import stx.arw.Arrows;

typedef ArrowPair<A,B,C,D> = Arrow<Tuple2<A,C>,Tuple2<B,D>>; 

abstract PairArrow<A,B,C,D>(ArrowPair<A,B,C,D>) from ArrowPair<A,B,C,D> to ArrowPair<A,B,C,D>{
	public function new(l:Arrow<A,B>,r:Arrow<C,D>){
		return new Arrow(
			inline function(?i : Tuple2<A,C>, cont : Function1<Tuple2<B,D>,Void> ) : Void{
				var ol : Maybe<B> 	= null;
				var or : Maybe<D> 	= null;

				var merge 	=
					function(l:B,r:D){
						cont( Tuples.t2(l,r) );
					}
				var check 	=
					function(){
						if (((ol!=null) && (or!=null))){
							merge(Maybes.get(ol),Maybes.get(or));
						}
					}
				var hl 		= 
					function(v:B){
						ol = v == null ? None : Some(v);
						check();
					}
				var hr 		=
					function(v:D){
						or = v == null ? None : Some(v);
						check();
					}
				l.withInput( i._1 , hl );
				r.withInput( i._2 , hr );
			}
		);
	}
	public function apply(?i){
		return this.apply(i);
	}
}