package stx.ifs;

import Stax.*;
import stx.Fail;

import stx.Prelude;

using stx.Option;
using stx.Functions;
using stx.Compose;

typedef ApplyType<I,O> = {
	function apply(v:I):O;
}
interface Apply<I,O>{
	public function apply(v:I):O;
}
class DefaultApply<E,A> implements Apply<E,A>{
	public function new( ){

	}
	public function apply(v:E):A{
		return except()(fail(AbstractMethodFail()));
	}
}
class ApplyDelegate<E,A> implements Apply<E,A>{
  private var __apply__ : E -> A;
  public function new(__apply__){
    this.__apply__ = __apply__;
  }
  public function apply(e:E):A{
    return __apply__(e);
  }
}