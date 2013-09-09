package hx.ds.ifs;

interface Enumerator<T> {
	public function next():T;
	public function hasNext():Bool;
}