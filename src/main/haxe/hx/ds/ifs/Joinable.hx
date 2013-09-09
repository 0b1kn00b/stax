package stx.ds.ifs;

import stx.mcr.Self;

interface Joinable<V> extends SelfSupport{
	
	@edit public function add(value:V):Self;
	@edit public function cons(value:V):Self;
	
	@edit public function append(values:Enumerable<V>):Self;
	@edit public function prepend(values:Enumerable<V>):Self;
}