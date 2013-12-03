package stx.reactive;
import stx.test.Suite;
using stx.test.Assert;

import stx.reactive.Streams;
import stx.reactive.Reactive;

import haxe.Timer;

class StreamTest extends Suite{
	public function testFlatMap(){
		trace('start');
		var as = Assert.createAsync(function(){},1200);

		var s0 = Streams.pure();
		var s1 = Streams.pure();

		var tracer = function(y){ trace(y); }

		s0.each( tracer );
		
		s0.flatMap(
			function(x:Int){
				Timer.delay(
					function(){
						var fn = function(x) { return x * 10; }
						s1.sendEvent( fn(x) );
					},
					1000
				);
				return s1;
			}
		).each( tracer );

		s0.sendEvent(1);
		s0.sendEvent(2);
	}
}