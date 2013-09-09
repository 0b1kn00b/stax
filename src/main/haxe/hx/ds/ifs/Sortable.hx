package stx.ds.ifs;

import stx.mcr.Self;

interface Sortable<T> extends SelfSupport{
	public function sort():Self;
	public function sortWith(fn V -> V -> Int):Self;
}