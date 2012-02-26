package stax;

/**
 * ...
 * @author 0b1kn00b
 */
import stax.Tuples;

class Hashes {

	public static function toHash<A>(iter:Array < Tuple2 < String, A >> ):Hash<A> {
		var hash = new Hash();
		for (val in iter) {
			hash.set( val._1 , val._2);
		}
		return hash;
	}
	
}