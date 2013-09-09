package stx.ds.ifs;

import stx.mcr.Self;

interface Insertable<K,V> extends SelfSupport{
	public function insertBefore(key:K, value:V):Self;
	public function insertAfter(key:K, value:V):Self;
}