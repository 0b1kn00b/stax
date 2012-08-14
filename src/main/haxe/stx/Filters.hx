package stx;

/**
 * ...
 * @author 0b1kn00b
 */
using stx.Iterables;
using SCore;

class Filters {

	static public function filterNotNulls<A>(iter:Iterable<A>):Iterable<A>{
		return iter.filter( function(e) return e != null );
	}
	static public function filterNulls<A>(iter:Iterable<A>):Iterable<A>{
		return iter.filter( function(e) return e == null );
	}
}