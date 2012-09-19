package stx;

import stx.Tuples;  		using stx.Tuples;
												using stx.Iterators;
using stx.Prelude;

class Hashes {
	/**
		Creates an Iterable of Tuple2<Key,Value> from a Hash.
	*/
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
	/**
		Returns whether all the keys are in the hash
	*/
	public static inline function hasAllKeys<A>(h:Hash<A>, keys:Array<String>):Bool {
		var ok = true;
		
		for (val in keys) {
			if ( !h.exists(val) ) {
				ok = false;
				break;
			}
		}
		return ok;
	}
	/**
		Returns whether any of the keys are in the Hash
	*/
	public static inline function hasAnyKey<A>(h:Hash<A>, entries:Array<String>):Bool {
		for (val in entries) {
			if ( h.exists(val) ) {
				return true;
			}
		}
		return false;		
	}
}