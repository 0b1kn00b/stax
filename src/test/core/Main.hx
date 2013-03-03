
using stx.Prelude;
using stx.macro.F;
using stx.Future;
using stx.Log;
using stx.plus.Equal;
using stx.plus.Order;
using stx.Functions;
using stx.Maybes;
		
import stx.io.json.Json;

class Main{
	static function main(){
		new Main();
	}
	public function new(){
		new AllClasses();

		[1,2,3]
			.map(F.n(a,return a+1))
			.map(stx.Future.pure)
			.waitFor()
			.foreach(Log.printer());

		trace( [1,2,3].equals([1,2,3]) );
		trace( [1,2,3].equals([1,2,5]) );

		var a = ArrayOrder.sort.lazy([99,2,6,-55	]);
		trace( a() );
		var b = { a : 123, 'b' : [4,5,6] };
		
		trace( Json.decode( Json.encode( Json.fromObject(b) ) ) );
	}
}