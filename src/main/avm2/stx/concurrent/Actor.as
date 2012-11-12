package stx.concurrent {
	import stx.concurrent.ActorStatus;
	import stx.Future;
	public interface Actor {
		function send(data : *) : stx.Future ;
		function load() : Number ;
		function stop() : stx.Future ;
		function start() : stx.Future ;
		function status() : stx.concurrent.ActorStatus ;
	}
}
