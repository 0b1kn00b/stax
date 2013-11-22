package stx;

using stx.UnitTest;

using stx.Functions;
using Std;
using stx.Tuples;

using stx.State;
import stx.State.*;

class StateTest extends TestCase{
	public function test(u:UnitArrow):UnitArrow{
		var f 	= 'blah';
		var sr 	= f.newVar();
		//$type( sr );
		var fn = function(x) return x;
		var sr2 = sr.map( fn );
		//$type(fn);

		var fn2 = modifier.bind(function(x) { return '$x hmm'; });
		var fn3 = modifier.bind(function(x:String):String { return '$x rooga'; });

		//$type( fn2 );
		//sr.apply(null).then( fn2 );
		//trace( untyped sr(null).fst() );	}
		var sr3 = 'pooty'.newVar();

		var val = sr.flatMap( fn2 ).flatMap( fn3 );
		//$type (val.map) ;
		//trace(val.eval());
		var val2 = sr.flatMap( reader );
		//$type(val2);
		trace(val2.exec(null));
		trace('___________');
		return u;
	}
}