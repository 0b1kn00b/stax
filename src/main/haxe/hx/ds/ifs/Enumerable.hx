package stx.ds.ifs;

interface Enumerable<T> {
	public function enumerator():Enumerator<T>;
}