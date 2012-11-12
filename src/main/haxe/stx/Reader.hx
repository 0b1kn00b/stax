package stx;
import stx.Prelude;

//http://www.youtube.com/watch?v=ZasXwtTRkio
class Reader<C,A>{
	@:noUsing
	static public function create<C,A>( opts: { apply : C -> A } ){
		return new Reader(opts);
	}
	@:noUsing
	static public function unit<A,B>(fn:A->B){
		return create( { apply :  fn } );
	}
	@:noUsing
	static public function pure<C,A>(a:A):Reader<C,A>{
		return unit(function(c:C){ return a; });
	}

	public function new(opts: { apply : C -> A } ){
		this.apply = opts.apply;
	}
	dynamic public function apply(v:C):A{
		return null;
	}
	public function map<B>(f:A->B){
		return unit( function(i){ return f(apply(i)); } );
	}
	public function flatMap<B>(f:A->Reader<C,B>){
		return unit( function(i){ return f(apply(i)).apply(i); } );
	}
}
class Readers{
	static public function map<V,A,B>(reader:Reader<V,A>,f:Function1<A,B>):Reader<V,B>{
		return reader.map(f);
	}
	static public function flatMap<V,A,B>(reader:Reader<V,A>,f:Function1<A,Reader<V,B>>):Reader<V,B>{
		return reader.flatMap(f);
	}
}