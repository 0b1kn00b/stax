package stx.arw;

using stx.arw.Arrows;
import stx.Prelude;

class MapArrow <I,O> implements Arrow<Iterable<I>,Iterable<O>>{
	var a : Arrow<I,O>;
	public function new(fn:Arrow<I,O>) {
		this.a = fn;
	}
	inline public function withInput(?i : Iterable<I>, cont : Function1< Iterable<O>, Void > ) {
		trace(i);
		var iter 	= i.iterator();
		var o 		= [];
		var index = 0;
		return 
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
	}
	public static function mapper<I,O,P>(a:Arrow<I,O>):Arrow<Iterable<I>,Iterable<O>>{
		return new MapArrow(a);
	}
}