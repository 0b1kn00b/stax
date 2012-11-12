package stx.ds._List {
	import stx.Option;
	import stx.ds.List;
	import flash.Boot;
	public class Cons extends stx.ds.List {
		public function Cons(tools : * = null,head : * = null,tail : stx.ds.List = null) : void { if( !flash.Boot.skip_constructor ) {
			super(tools);
			this._head = head;
			this._tail = tail;
			this._size = tail.size() + 1;
		}}
		
		public override function size() : int {
			return this._size;
		}
		
		public override function getLastOption() : stx.Option {
			return stx.Option.Some(this.getLast());
		}
		
		public override function getHeadOption() : stx.Option {
			return stx.Option.Some(this.getHead());
		}
		
		public override function getTail() : stx.ds.List {
			return this._tail;
		}
		
		public override function getLast() : * {
			var cur : stx.ds.List = this;
			{
				var _g1 : int = 0, _g : int = this.size() - 1;
				while(_g1 < _g) {
					var i : int = _g1++;
					cur = cur.getTail();
				}
			}
			return cur.getHead();
		}
		
		public override function getHead() : * {
			return this._head;
		}
		
		protected var _size : int;
		protected var _tail : stx.ds.List;
		protected var _head : *;
	}
}
