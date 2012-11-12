package stx.time {
	import haxe.Timer;
	import stx.time.ScheduledExecutor;
	import stx.Future;
	public class ScheduledExecutorSystem implements stx.time.ScheduledExecutor{
		public function ScheduledExecutorSystem() : void {
		}
		
		public function forever(f : Function,ms : int) : stx.Future {
			var future : stx.Future = new stx.Future();
			var timer : haxe.Timer = new haxe.Timer(ms);
			future.ifCanceled(timer.stop);
			timer.run = f;
			return future;
		}
		
		public function repeatWhile(_tmp_seed : *,_tmp_f : Function,ms : int,_tmp_pred : Function) : stx.Future {
			var seed : * = _tmp_seed, f : Function = _tmp_f, pred : Function = _tmp_pred;
			var future : stx.Future = new stx.Future();
			return ((pred(seed))?(function($this:ScheduledExecutorSystem) : stx.Future {
				var $r : stx.Future;
				var result : * = seed;
				var timer : haxe.Timer = new haxe.Timer(ms);
				future.ifCanceled(timer.stop);
				timer.run = function() : void {
					result = f(result);
					if(!pred(result)) {
						timer.stop();
						future.deliver(result,{ fileName : "ScheduledExecutor.hx", lineNumber : 130, className : "stx.time.ScheduledExecutorSystem", methodName : "repeatWhile"});
					}
				}
				$r = future;
				return $r;
			}(this)):future.deliver(seed,{ fileName : "ScheduledExecutor.hx", lineNumber : 136, className : "stx.time.ScheduledExecutorSystem", methodName : "repeatWhile"}));
		}
		
		public function repeat(_tmp_seed : *,_tmp_f : Function,ms : int,times : int) : stx.Future {
			var seed : * = _tmp_seed, f : Function = _tmp_f;
			var future : stx.Future = new stx.Future();
			return ((times > 0)?(function($this:ScheduledExecutorSystem) : stx.Future {
				var $r : stx.Future;
				var result : * = seed;
				var timer : haxe.Timer = new haxe.Timer(ms);
				future.ifCanceled(timer.stop);
				timer.run = function() : void {
					result = f(result);
					--times;
					if(times == 0) {
						timer.stop();
						future.deliver(result,{ fileName : "ScheduledExecutor.hx", lineNumber : 105, className : "stx.time.ScheduledExecutorSystem", methodName : "repeat"});
					}
				}
				$r = future;
				return $r;
			}(this)):future.deliver(seed,{ fileName : "ScheduledExecutor.hx", lineNumber : 111, className : "stx.time.ScheduledExecutorSystem", methodName : "repeat"}));
		}
		
		public function once(_tmp_f : Function,ms : int) : stx.Future {
			var f : Function = _tmp_f;
			var run : Boolean = false;
			var future : stx.Future = new stx.Future();
			var timer : haxe.Timer = haxe.Timer.delay(function() : void {
				run = true;
				future.deliver(f(),{ fileName : "ScheduledExecutor.hx", lineNumber : 70, className : "stx.time.ScheduledExecutorSystem", methodName : "once"});
			},ms);
			future.allowCancelOnlyIf(function() : Boolean {
				return ((run)?false:function() : Boolean {
					var $r : Boolean;
					timer.stop();
					$r = true;
					return $r;
				}());
			});
			return future;
		}
		
	}
}
