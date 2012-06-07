package stx;

/**
 * ...
 * @author 0b1kn00b
 */
import stx.Prelude;
using stx.Options;

class Iterators {
	public static function yield<A>(fn:Void->Option<A>) : Iterator<A> { 
		var state = null;
		var val 	= null;
		return{
			next :
				function(){
					if(state == null){
						state = fn();
						val 	= state.get();
					}
					return val;
				},
			hasNext :
				function(){
					if(state == null){
						state = fn();
					}
					var o = switch (state) {
						case Some(v) 	: true;
						case None 		: false;
					}
					if(o){
						val  	= state.get();
					}
					state = fn();
					return o;
				}
		}
  }
}