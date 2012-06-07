package stx;

/**
 * ...
 * @author 0b1kn00b
 */
using stx.Iterables;
using Stax;

class Filters {

	public static function filterIsNotNull<A>(iter:Iterable<A>):Iterable<A>{
		return iter.filter( function(e) return e != null );
	}
	public static function filterIsNull<A>(iter:Iterable<A>):Iterable<A>{
		return iter.filter( function(e) return e == null );
	}
}