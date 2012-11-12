package stx.math.tween {
	import stx.framework.Injector;
	import stx.time.ScheduledExecutor;
	import stx.Future;
	import stx.Floats;
	public class TweenerExtensions {
		static protected var DefaultFrequency : int = stx.Floats.round(1000.0 / 24.0);
		static public function startWith(tweener : Function,easing : Function) : Function {
			return function(t : Number) : * {
				return tweener(easing(t));
			}
		}
		
		static public function endWith(tweener : Function,easing : Function) : Function {
			return stx.math.tween.TweenerExtensions.startWith(tweener,function(t : Number) : Number {
				return 1.0 - easing(1.0 - t);
			});
		}
		
		static public function animate(tweener : Function,duration : int,frequency_ : * = 0,cb : Function) : stx.Future {
			if(frequency_==null) frequency_=0;
			var executor : stx.time.ScheduledExecutor = stx.framework.Injector.inject(stx.time.ScheduledExecutor,{ fileName : "TweenExtensions.hx", lineNumber : 53, className : "stx.math.tween.TweenerExtensions", methodName : "animate"});
			var frequency : * = ((frequency_ > 0)?frequency_:stx.math.tween.TweenerExtensions.DefaultFrequency);
			return executor.repeat(frequency,function(millis : *) : int {
				var t : Number = millis / duration;
				cb(tweener(t));
				return millis + frequency;
			},frequency,stx.Floats.ceil(duration / frequency));
		}
		
	}
}
