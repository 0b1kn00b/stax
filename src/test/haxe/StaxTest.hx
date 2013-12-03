import stx.test.Suite;
import stx.test.Assert;

using Prelude;
using Stx;


class StaxTest extends Suite{
	public function testUsings<T>(){
		trace('start');
		//def(c);//constant
		//def(var a : String);//evars
		//var fnc = F.n(var b : Array<Int>,return b.map(F.n(x,return x + 1)));//evars with param
		//trace(fnc([1,2,3]));
		//var fnc2 = F.n([a,var b : String],return a + 1 + b);
		//trace(fnc2(19,'100'));
		
		//def( var a : {thing : A});
		//def({ value : String });
		//var a = F.n(a,return a);
//		trace(tup(fnc,2));
		/*var mapper = fn({x+3;});
		var c = [1,2,3].map(mapper);*/
		//trace(c);//[4,5,6]

	/*	var a = Eventual.pure('a');
		var b = Eventual.pure('b');
		var c = Eventual.pure('c');

		[a,b,c].map(def(v,return v.map(Right)))
		.foldl(
			Eventual.pure(Right([])),
			stx.Promises.waitfold
		).each( Log.printer() );

		trace(
			['a','b','c'].foldl(
			'start:',
			def([init,v],return init + v)
			)
		);*/
	}
	public function testWeave(){
		//trace('a'.ergo());
	}
}
/*abstract Opaque {

    public inline function new(x) {
        this = x;
    }

    public function incr() {
        return ++this;
    }
   
    public inline function toInt() : Int {
        return this;
    }

}*/