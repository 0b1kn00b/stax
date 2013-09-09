package stx;

import Stax.*;
import haxe.PosInfos;

import stx.Tuples;
import stx.Prelude;
import stx.Fail;
 
import stx.plus.Equal;
import stx.Compare;

using stx.Compose;
using stx.Functions;
using stx.Compose;
using stx.Bools;
using stx.Anys;
using stx.Options;
using stx.Tuples;
using stx.Assert;

class Assert{
	@:noUsing static public function assert<T>(prd:Predicate<T>,?v:T,?er:Fail,?pos:PosInfos){
		er = er == null ? fail(AssertionFail(Std.string(v),'assert failed',pos)) : er;
		if(!prd.apply(v)){
			throw(er);
		}
	}
}