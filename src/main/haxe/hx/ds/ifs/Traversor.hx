package stx.ds.ifs;

/**
 * Provides support for Dual direction iterators.
 */
interface Traversor<T> extends Enumerator<T> {
	public function back():T;
	public function hasBack():Bool;
}