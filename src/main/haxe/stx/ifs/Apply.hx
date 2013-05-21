package stx.ifs;

import stx.Prelude;
import stx.err.AbstractMethodError;

using stx.Options;
using stx.Functions;
using stx.Compose;

typedef TApply<I,O> = {
	function apply(v:I):O;
}
interface IApply<I,O>{
	public function apply(v:I):O;
}
class Apply<E,A> implements IApply<E,A>{
	public function new( ){

	}
	public function apply(v:E):A{
		return Prelude.err()( new AbstractMethodError() );
	}
}