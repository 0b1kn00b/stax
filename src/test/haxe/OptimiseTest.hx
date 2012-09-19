import stx.test.TestCase;
using stx.test.Assert;
import haxe.Timer;
using stx.Prelude;

class OptimiseTest extends TestCase{
	@:note('#0b1kn00b: currently running at about 1/10th native performance')
	public function testMap(){
		var n = 10000000;

		var a = [];

		for (t in 0...n){
			a.push(1);
		}

		var t = Timer.stamp();

		for( i in 0...a.length ){
			a[i] = a[i]++;
		}

		trace(t - Timer.stamp() );
		t = Timer.stamp();

		a.map(
			inline function(x){
				return x+1;
			}
		);
		trace(t - Timer.stamp() );
		t = Timer.stamp();
	}
}