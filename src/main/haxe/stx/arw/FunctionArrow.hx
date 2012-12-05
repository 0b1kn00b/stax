package stx.arw;
class FunctionArrow<I,O> extends Arrow<I,O> {
	var f : Function1<I,O>;
	public function new (m : Function<I,O>) { this.f = m;}

	inline public function withInput(?i : I, cont : Function1<O,Void>) : Void { cont(f(i)); }
}