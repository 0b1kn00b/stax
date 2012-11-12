package stx.time {
	import stx.Future;
	public interface ScheduledExecutor {
		function forever(f : Function,ms : int) : stx.Future ;
		function repeatWhile(seed : *,f : Function,ms : int,pred : Function) : stx.Future ;
		function repeat(seed : *,f : Function,ms : int,times : int) : stx.Future ;
		function once(f : Function,ms : int) : stx.Future ;
		;
	}
}
