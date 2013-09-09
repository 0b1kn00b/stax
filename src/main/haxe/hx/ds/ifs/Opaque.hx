package stx.ds.ifs;

/**
 * ...
 * @author 0b1kn00b
 */

 /**
  * Describes a collection with one entry point and one exit point.
  */
interface Opaque<T> extends Collection<T>{
	/**
	 * Adds an element.
	 * @param	v
	 */
	public function adjoin(v:T):Self;
	
	/**
	 * Removes and returns an element.
	 * @return
	 */
	public function disjoin():T;
	
	/**
	 * Look at whatever the first value is.
	 */
	public function peek():T;
}