package stx.reactive {
	import haxe.Timer;
	public class External {
		static public var setTimeout : Function = function(f : Function,time : int) : * {
			return haxe.Timer.delay(f,time);
		}
		static public var cancelTimeout : Function = function(timer : *) : void {
			(function() : haxe.Timer {
				var $r : haxe.Timer;
				var $t : * = timer;
				if(Std._is($t,haxe.Timer)) (($t) as haxe.Timer);
				else throw "Class cast error";
				$r = $t;
				return $r;
			}()).stop();
		}
		static public var now : Function = function() : Number {
			return Date["now"]().getTime();
		}
	}
}
