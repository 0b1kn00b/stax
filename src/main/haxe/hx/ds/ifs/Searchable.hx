package stx.ds.ifs;

interface Searchable<Q,V>{
  public function findOne(q:Q):V;
	public function findAll(q:Q):Array<V>;
}