package stx.arw;

import stx.Tuples;

using stx.Tuples;
import Prelude;
using stx.Arrow;

typedef ArrowPair<A,B,C,D> = Arrow<Tuple2<A,C>,Tuple2<B,D>>; 

abstract PairArrow<A,B,C,D>(ArrowPair<A,B,C,D>) from ArrowPair<A,B,C,D> to ArrowPair<A,B,C,D>{
	public function new(l:Arrow<A,B>,r:Arrow<C,D>){
		this = new Arrow(
			inline function(?i : Tuple2<A,C>, cont : Function1<Tuple2<B,D>,Void> ) : Void{
				var ol : Option<B> 	= null;
				var or : Option<D> 	= null;

				var merge 	=
					function(l:B,r:D){
						cont( tuple2(l,r) );
					}
				var check 	=
					function(){
						if (((ol!=null) && (or!=null))){
							merge(Options.getOrElseC(ol,null),Options.getOrElseC(or,null));
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
				l.withInput( i.fst() , hl );
				r.withInput( i.snd() , hr );
			}
		);
	}
}