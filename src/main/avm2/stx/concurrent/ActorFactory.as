package stx.concurrent {
	import stx.concurrent.Actor;
	public interface ActorFactory {
		function createStateless(loop : Function,coalescer : * = null) : stx.concurrent.Actor ;
		function create(handler : Function,coalescer : * = null) : stx.concurrent.Actor ;
	}
}
