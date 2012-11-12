package stx.reactive {
	import haxe.Timer;
	public class Arrows {
		static public function trampoline(f : Function) : Function {
			return function(x : *) : void {
				haxe.Timer.delay(function() : void {
					f(x);
				},10);
			}
		}
		
	}
}
