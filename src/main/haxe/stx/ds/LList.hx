package stx.ds;

enum LList<E> {
	Cons(e : E, t : LList<E>);
	Nil;
}
class LLists{
	static public function create<A>():LList<A>{
		return LList.Nil;
	}
	static public function cons<A>(l:LList<A>,v:A):LList<A>{
		return LList.Cons(v,l);
	}
}