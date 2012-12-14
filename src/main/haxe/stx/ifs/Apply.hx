package stx.ifs;
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
	static public function pure(){
		return unit(Compose.pure());
	}
	@:noUsing
	static public function unit<A,B>(fn:A->B){
		return create( { apply :  fn } );
	}
	@:noUsing
	static public function create<A,B>( opts : TApply<A,B> ){
		return new Apply( opts );
	}
	public function new( ?opts :  TApply<E,A> ){
		if (opts!=null && opts.apply != null) this.apply = opts.apply;
	}
	public dynamic function apply(v:E):A{
		return Prelude.error()('apply not implemented');
	}
	public function map<B>(f:A->B):Apply<E,B>{
		return 
			unit( apply.then(f) );
	}
}