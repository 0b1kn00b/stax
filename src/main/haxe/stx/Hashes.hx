package stx;

/**
 * ...
 * @author 0b1kn00b
 */
import stx.Tuples;  		using stx.Tuples;
												using stx.Iterators;
using SCore;

class Hashes {

/*	public static function toHash<A>(iter:Array < Tuple2 < String, A >> ):Hash<A> {
		var hash = new Hash();
		for (val in iter) {
			hash.set( val._1 , val._2);
		}
		return hash;
	}*/
	public static function fromHash<A>(h:Hash<A>):Iterable<Tuple2<String,A>>{
		return
			h.keys().toIterable().map(
				function(x:String){
					var val : A = h.get(x); 
					return
						x.entuple( val );
				}
			);
	}
	public static inline function hasAll(h:Hash<Dynamic>, entries:Array<String>):Bool {
		var ok = true;
		
		for (val in entries) {
			if ( !h.exists(val) ) {
				ok = false;
				break;
			}
		}
		return ok;
	}
	public static inline function hasAny(h:Hash<Dynamic>, entries:Array<String>):Bool {
		for (val in entries) {
			if ( h.exists(val) ) {
				return true;
			}
		}
		return false;		
	}
}
class HashType{
	static public function exists<A>(h:Hash<A>,str:String){
		return h.exists(str);
	}
}