package stx.ifs;

using stx.Options;
using stx.Functions;
using stx.Compose;

typedef TApply<I,O> = {
	function apply(v:I):O;
}
interface IApply<I,O>{
	dynamic public function apply(v:I):O;
}
class Apply<E,A> implements IApply<E,A>{
	@:noUsing
	static public function unit(){
		return pure(Compose.unit());
	}
	@:noUsing
	static public function pure<A,B>(fn:A->B){
		return create( { apply :  fn } );
	}
	@:noUsing
	static public function create<A,B>( opts : TApply<A,B> ){
		return new Apply( opts );
	}
	public function new( ?opts :  TApply<E,A> ){
		Opt.n(opts)
			.flatMap(function(x) {return Opt.n(x.apply);})
			.foreach(function(x) {this.apply = x;});
	}
	public dynamic function apply(v:E):A{
		return Prelude.error()('apply not implemented');
	}
}