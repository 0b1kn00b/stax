package stx;

import stx.test.TestCase;
import stx.test.Assert;

													using stx.States;
													using stx.Functions;
													using Std;

class StateTest extends TestCase{
	public function new(){
		super();
	}
	public function test(){
		var f 	= 'blah';
		var sr 	= f.newVar();
		//$type( sr );
		var fn = function(x) return x;
		var sr2 = sr.map( fn );
		//$type(fn);

		var fn2 = function(x:String):String { return '$x hmm'; }.modifier;
		var fn3 = function(x:String):String { return '$x rooga'; }.modifier;

		//$type( fn2 );
		//sr.apply(null).then( fn2 );
		//trace( untyped sr(null)._1 );	}
		var sr3 = new stx.States.StateRef('pooty');
		var val = sr.flatMap( fn2 ).flatMap( fn3 );
		//$type (val.map) ;
		trace(val.apply(null)._1);
		var val2 = sr.flatMap( StateRefs.reader );
		trace(val2.apply(null));
		trace('___________');
	}
}