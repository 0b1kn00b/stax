package stx.async.arrowlet;

using stx.async.Arrowlet;
import Prelude;

abstract Map <I,O>(Arrowlet<Iterable<I>,Iterable<O>>){
	
	public function new(fn:Arrowlet<I,O>){
		this = null;
	/*	this = new Arrowlet(inline function(?i:Iterable<I>, cont:Function1<Iterable<O>,Void>){
			var iter 	= i.iterator();
			var o 		= [];
			var index = 0;
			 new RepeatArrowlet(
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
	/*public static function mapper<I,O,P>(a:Arrowlet<I,O>):Arrowlet<Iterable<I>,Iterable<O>>{
		return new MapArrowlet(a);
	}*/
}