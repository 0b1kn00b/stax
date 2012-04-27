package stx;

/**
 * ...
 * @author 0b1kn00b
 */

class Iterators {

	public static function foreach<A>(it : Iterator<T>, f : A -> Void) : Void
	{
		for (o in it)
			f(o);
	}
	public static inline var each = foreach;
	
}