package stx;

using stx.Tuples;
using stx.Iterators;
using stx.Prelude;
using stx.Options;

class Maps {
	/**
		Creates an Iterable of Tuple2<Key,Value> from a Map.
	*/
	static public function fromMap<K,V>(h:Map<K,V>):Iterable<Tuple2<K,V>>{
		return
			h.keys().toIterable().map(
				function(x:K){
					var val : V = h.get(x); 
					return tuple2(x, val);
				}
			);
	}
	/**
		Returns whether all the keys are in the hash
	*/
	static public inline function hasAllKeys<K,V>(h:Map<K,V>, keys:Array<K>):Bool {
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
		Returns whether any of the keys are in the Map
	*/
	static public inline function hasAnyKey<K,V>(h:Map<K,V>, entries:Array<K>):Bool {
		for (val in entries) {
			if ( h.exists(val) ) {
				return true;
			}
		}
		return false;		
	}
	static public inline function getOption<K,V>(map:Map<K,V>,key:K):Option<V>{
	 	return Options.create(map.get(key));
	}
}