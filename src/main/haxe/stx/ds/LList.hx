package stx.ds;

enum LList<E> {
	Cons(e : E, t : LList<E>);
	Nil();
}