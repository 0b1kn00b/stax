package stx.arw;

using stx.Arrow;
import stx.Prelude;

abstract MapArrow <I,O>(Arrow<Iterable<I>,Iterable<O>>){
	
	public function new(fn:Arrow<I,O>){
		this = null;
	/*	this = new Arrow(inline function(?i:Iterable<I>, cont:Function1<Iterable<O>,Void>){
			var iter 	= i.iterator();
			var o 		= [];
			var index = 0;
			 new RepeatArrow(
			 		function(iter){
			 			return iter.hasNext() ? Some( iter.next() ) : None;
			 		}.lift()
			 	.then( a.option() )
			 	.then(
			 		function(x){
			 			return 
				 			switch (x) {
				 				case None 		: Done(o);
				 				case Some(v) 	:
				 				 
				 					o.push(v);
				 					Cont( iter );
				 			}
			 		}.lift()
			 	 )
			 ).withInput( iter , cont);
		});*/
	}
	public function apply(?i){
    return this.apply(i);
  }
	/*public static function mapper<I,O,P>(a:Arrow<I,O>):Arrow<Iterable<I>,Iterable<O>>{
		return new MapArrow(a);
	}*/
}