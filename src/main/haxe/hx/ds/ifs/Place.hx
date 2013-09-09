package stx.ds.ifs;

import stx.mcr.Self;

interface Place<K,V> extends SelfSupport{
	public function set(key:K, value:V):Self;
}