package stx.reactive {
	import stx.reactive.Arrow;
	import hxevents.Dispatcher;
	public class EventArrow implements stx.reactive.Arrow{
		public function EventArrow() : void {
		}
		
		public function withInput(_tmp_i : * = null,_tmp_cont : Function) : void {
			var i : hxevents.Dispatcher = _tmp_i, cont : Function = _tmp_cont;
			var canceller : Function = null;
			var handler : Function = function(evt : *) : void {
				canceller();
				cont(evt);
			}
			i.add(handler);
			canceller = function() : void {
				i.remove(handler);
			}
		}
		
		static public function eventA() : stx.reactive.Arrow {
			return new stx.reactive.EventArrow();
		}
		
	}
}
