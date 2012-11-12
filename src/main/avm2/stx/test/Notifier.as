package stx.test {
	import stx.test._Dispatcher.EventException;
	import flash.Boot;
	public class Notifier {
		public function Notifier() : void { if( !flash.Boot.skip_constructor ) {
			this.handlers = new Array();
		}}
		
		public function has() : Boolean {
			return this.handlers.length > 0;
		}
		
		public function dispatch() : Boolean {
			try {
				var list : Array = this.handlers.copy();
				{
					var _g : int = 0;
					while(_g < list.length) {
						var l : Function = list[_g];
						++_g;
						l();
					}
				}
				return true;
			}
			catch( exc : stx.test._Dispatcher.EventException ){
				return false;
			}
			return false;
		}
		
		public function clear() : void {
			this.handlers = new Array();
		}
		
		public function remove(h : Function) : Function {
			{
				var _g1 : int = 0, _g : int = this.handlers.length;
				while(_g1 < _g) {
					var i : int = _g1++;
					if(Reflect.compareMethods(this.handlers[i],h)) return this.handlers.splice(i,1)[0];
				}
			}
			return null;
		}
		
		public function add(h : Function) : Function {
			this.handlers.push(h);
			return h;
		}
		
		protected var handlers : Array;
		static public function stop() : void {
			throw stx.test._Dispatcher.EventException.StopPropagation;
		}
		
	}
}
