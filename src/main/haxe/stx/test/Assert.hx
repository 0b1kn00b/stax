package stx.test;

import Stax.*;
import haxe.PosInfos;

import stx.Tuples;
import Prelude;
import stx.Fail;
 
import stx.Equal;
import stx.Compare;

using stx.Compose;
using stx.Functions;
using stx.Compose;
using stx.Bools;
using stx.Anys;
using stx.Option;
using stx.Tuples;
using stx.test.Assert;

@doc("
  Use in conjunction with stx.Compare for generating arbitrary assertions.
")
class Assert{
	@:noUsing static public inline function assert<T>(?v:Null<T>,?str:String,?prd:Predicate<Null<T>>,?er:Fail,?pos:PosInfos):Void{
    prd = prd == null ? Compare.ntnl()                                    : prd;
		er  = er  == null ? fail(AssertionError(str == null ? Std.string(v)   : str,'assert failed',pos)) : er;
		if(!prd.apply(v)){
			throw(er);
		}
	}
}