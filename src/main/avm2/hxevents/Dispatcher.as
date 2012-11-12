package hxevents {
	import flash.Boot;
	public class Dispatcher {
		public function Dispatcher() : void { if( !flash.Boot.skip_constructor ) {
			var _g : hxevents.Dispatcher = this;
			if(this.add == null) this.add = function(h : Function) : Function {
				_g.handlers.push(h);
				return h;
			}
			this.handlers = new Array();
		}}
		
		public function stop() : void {
			this._stop = true;
		}
		
		protected var _stop : Boolean;
		public function has(h : Function = null) : Boolean {
			if(null == h) return this.handlers.length > 0;
			else {
				{
					var _g : int = 0, _g1 : Array = this.handlers;
					while(_g < _g1.length) {
						var handler : Function = _g1[_g];
						++_g;
						if(h == handler) return true;
					}
				}
				return false;
			}
			return false;
		}
		
		public function dispatchAndAutomate(e : *) : void {
			this.dispatch(e);
			this.handlers = [];
			this.add = function(h : Function) : Function {
				h(e);
				return h;
			}
		}
		
		public function dispatch(e : *) : void {
			var list : Array = this.handlers.copy();
			{
				var _g : int = 0;
				while(_g < list.length) {
					var l : Function = list[_g];
					++_g;
					if(this._stop == true) {
						this._stop = false;
						break;
					}
					l(e);
				}
			}
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
		
		public function addOnce(h : Function) : Function {
			var me : hxevents.Dispatcher = this;
			var _h : Function = null;
			_h = function(v : *) : void {
				me.remove(_h);
				h(v);
			}
			this.add(_h);
			return _h;
		}
		
		public var add : Function;
		protected var handlers : Array;
	}
}
