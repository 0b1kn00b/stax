package stx.ds {
	import stx.ds.Collection;
	import stx.plus.ArrayShow;
	import stx.ds._List.Cons;
	import flash.Boot;
	import stx.ds._List.Nil;
	import stx.plus.ArrayEqual;
	import stx.Ints;
	import stx.Option;
	import stx.Tuple2;
	import stx.plus.Show;
	import stx.plus.Equal;
	import stx.functional.Foldable;
	import stx.plus.ArrayOrder;
	import stx.plus.Hasher;
	import stx.plus.Order;
	import stx.Tuples;
	import stx.functional.Foldables;
	public class List implements stx.ds.Collection{
		public function List(tools : * = null) : void { if( !flash.Boot.skip_constructor ) {
			if(tools != null) {
				this._order = tools.order;
				this._equal = tools.equal;
				this._hash = tools.hash;
				this._show = tools.show;
			}
		}}
		
		public function getTail() : stx.ds.List {
			return Prelude.error("List has no head",{ fileName : "List.hx", lineNumber : 432, className : "stx.ds.List", methodName : "getTail"});
		}
		
		public function getLastOption() : stx.Option {
			return stx.Option.None;
		}
		
		public function getHeadOption() : stx.Option {
			return stx.Option.None;
		}
		
		public function getLast() : * {
			return Prelude.error("List has no last element",{ fileName : "List.hx", lineNumber : 420, className : "stx.ds.List", methodName : "getLast"});
		}
		
		public function getHead() : * {
			return Prelude.error("List has no head element",{ fileName : "List.hx", lineNumber : 416, className : "stx.ds.List", methodName : "getHead"});
		}
		
		public function size() : int {
			return 0;
		}
		
		public function toString() : String {
			return "List " + stx.plus.ArrayShow.toStringWith(Prelude.SIterables.toArray(this),this.getShow());
		}
		
		public function hashCode() : int {
			var ha : Function = this.getHash();
			return this.foldl(12289,function(a : int,b : *) : int {
				return a * (ha(b) + 12289);
			});
		}
		
		public function compare(other : stx.ds.List) : int {
			return stx.plus.ArrayOrder.compareWith(Prelude.SIterables.toArray(this),Prelude.SIterables.toArray(other),this.getOrder());
		}
		
		public function equals(other : stx.ds.List) : Boolean {
			return stx.plus.ArrayEqual.equalsWith(Prelude.SIterables.toArray(this),Prelude.SIterables.toArray(other),this.getEqual());
		}
		
		public function getShow() : Function {
			return ((null == this._show)?((this.size() == 0)?stx.plus.Show.getShowFor(null):this._show = stx.plus.Show.getShowFor(this.getHead())):this._show);
		}
		
		public function getHash() : Function {
			return ((null == this._hash)?((this.size() == 0)?stx.plus.Hasher.getHashFor(null):this._hash = stx.plus.Hasher.getHashFor(this.getHead())):this._hash);
		}
		
		public function getEqual() : Function {
			return ((null == this._equal)?((this.size() == 0)?stx.plus.Equal.getEqualFor(null):this._equal = stx.plus.Equal.getEqualFor(this.getHead())):this._equal);
		}
		
		public function getOrder() : Function {
			return ((null == this._order)?((this.size() == 0)?stx.plus.Order.getOrderFor(null):this._order = stx.plus.Order.getOrderFor(this.getHead())):this._order);
		}
		
		protected var _show : Function;
		protected var _hash : Function;
		protected var _order : Function;
		protected var _equal : Function;
		public function withShowFunction(show : Function) : stx.ds.List {
			return stx.ds.List.create(Prelude.tool(this._order,this._equal,this._hash,show)).addAll(this);
		}
		
		public function withHashFunction(hash : Function) : stx.ds.List {
			return stx.ds.List.create(Prelude.tool(this._order,this._equal,hash,this._show)).addAll(this);
		}
		
		public function withEqualFunction(equal : Function) : stx.ds.List {
			return stx.ds.List.create(Prelude.tool(this._order,equal,this._hash,this._show)).addAll(this);
		}
		
		public function withOrderFunction(order : Function) : stx.ds.List {
			return stx.ds.List.create(Prelude.tool(order,this._equal,this._hash,this._show)).addAll(this);
		}
		
		public function iterator() : * {
			return stx.functional.FoldableExtensions.iterator(this);
		}
		
		public function sort() : stx.ds.List {
			var a : Array = Prelude.SIterables.toArray(this);
			a.sort(this.getOrder());
			var result : stx.ds.List = stx.ds.List.create(Prelude.tool(this._order,this._equal,this._hash,this._show));
			{
				var _g1 : int = 0, _g : int = a.length;
				while(_g1 < _g) {
					var i : int = _g1++;
					result = result.cons(a[a.length - 1 - i]);
				}
			}
			return result;
		}
		
		public function gaps(f : Function,equal : Function = null) : stx.ds.List {
			return stx.functional.FoldableExtensions.flatMapTo(this.zip(this.drop(1)),stx.ds.List.nil(null,Prelude.tool(null,equal)),function(tuple : stx.Tuple2) : stx.ds.List {
				return f(tuple._1,tuple._2);
			});
		}
		
		public function zip(that : stx.ds.List) : stx.ds.List {
			var len : int = stx.Ints.min(this.size(),that.size());
			var iterator1 : * = this.reverse().drop(stx.Ints.max(0,this.size() - len)).iterator();
			var iterator2 : * = that.reverse().drop(stx.Ints.max(0,that.size() - len)).iterator();
			var r : stx.ds.List = stx.ds.List.create();
			{
				var _g : int = 0;
				while(_g < len) {
					var i : int = _g++;
					r = r.cons(stx.Tuples.t2(iterator1.next(),iterator2.next()));
				}
			}
			return r;
		}
		
		public function reverse() : stx.ds.List {
			return this.foldl(stx.ds.List.create(Prelude.tool(this._order,this._equal,this._hash,this._show)),function(a : stx.ds.List,b : *) : stx.ds.List {
				return a.cons(b);
			});
		}
		
		public function filter(f : Function) : stx.ds.List {
			return this.foldr(stx.ds.List.create(Prelude.tool(this._order,this._equal,this._hash,this._show)),function(e : *,list : stx.ds.List) : stx.ds.List {
				return ((f(e))?list.cons(e):list);
			});
		}
		
		public function flatMap(f : Function) : stx.ds.List {
			return this.foldr(stx.ds.List.create(),function(e : *,list : stx.ds.List) : stx.ds.List {
				return list.prependAll(f(e));
			});
		}
		
		public function map(f : Function) : stx.ds.List {
			return this.foldr(stx.ds.List.create(),function(e : *,list : stx.ds.List) : stx.ds.List {
				return list.cons(f(e));
			});
		}
		
		public function take(n : int) : stx.ds.List {
			return this.reverse().drop(this.size() - n);
		}
		
		public function dropWhile(pred : Function) : stx.ds.List {
			var cur : stx.ds.List = this;
			{
				var _g1 : int = 0, _g : int = this.size();
				while(_g1 < _g) {
					var i : int = _g1++;
					if(pred(cur.getHead())) return cur;
					cur = cur.getTail();
				}
			}
			return cur;
		}
		
		public function drop(n : int) : stx.ds.List {
			var cur : stx.ds.List = this;
			{
				var _g1 : int = 0, _g : int = stx.Ints.min(this.size(),n);
				while(_g1 < _g) {
					var i : int = _g1++;
					cur = cur.getTail();
				}
			}
			return cur;
		}
		
		public function concat(l : stx.ds.List) : stx.ds.List {
			return this.addAll(l);
		}
		
		public function removeAll(_tmp_i : *) : * {
			var i : * = _tmp_i;
			var r : stx.ds.List = this;
			{ var $it : * = i.iterator();
			while( $it.hasNext() ) { var e : * = $it.next();
			r = r.remove(e);
			}}
			return r;
		}
		
		public function remove(_tmp_t : *) : * {
			var t : * = _tmp_t;
			var pre : Array = [];
			var post : stx.ds.List = stx.ds.List.nil(null,Prelude.tool(this._order,this._equal,this._hash,this._show));
			var cur : stx.ds.List = this;
			var eq : Function = this.getEqual();
			{
				var _g1 : int = 0, _g : int = this.size();
				while(_g1 < _g) {
					var i : int = _g1++;
					if(eq(t,cur.getHead())) {
						post = cur.getTail();
						break;
					}
					else {
						pre.push(cur.getHead());
						cur = cur.getTail();
					}
				}
			}
			pre.reverse();
			var result : stx.ds.List = post;
			{
				var _g2 : int = 0;
				while(_g2 < pre.length) {
					var e : * = pre[_g2];
					++_g2;
					result = result.cons(e);
				}
			}
			return result;
		}
		
		public function addAll(_tmp_i : *) : * {
			var i : * = _tmp_i;
			var a : Array = [];
			{ var $it : * = i.iterator();
			while( $it.hasNext() ) { var e : * = $it.next();
			a.push(e);
			}}
			a.reverse();
			var r : stx.ds.List = stx.ds.List.create(Prelude.tool(this._order,this._equal,this._hash,this._show));
			{
				var _g : int = 0;
				while(_g < a.length) {
					var e1 : * = a[_g];
					++_g;
					r = r.cons(e1);
				}
			}
			return this.foldr(r,function(b : *,a1 : stx.ds.List) : stx.ds.List {
				return a1.cons(b);
			});
		}
		
		public function add(_tmp_t : *) : * {
			var t : * = _tmp_t;
			return this.foldr(stx.ds.List.create(Prelude.tool(this._order,this._equal,this._hash,this._show)).cons(t),function(b : *,a : stx.ds.List) : stx.ds.List {
				return a.cons(b);
			});
		}
		
		public function contains(_tmp_t : *) : Boolean {
			var t : * = _tmp_t;
			var cur : stx.ds.List = this;
			var eq : Function = this.getEqual();
			{
				var _g1 : int = 0, _g : int = this.size();
				while(_g1 < _g) {
					var i : int = _g1++;
					if(eq(t,cur.getHead())) return true;
					cur = cur.getTail();
				}
			}
			return false;
		}
		
		public function foldr(z : *,f : Function) : * {
			var a : Array = Prelude.SIterables.toArray(this);
			var acc : * = z;
			{
				var _g1 : int = 0, _g : int = this.size();
				while(_g1 < _g) {
					var i : int = _g1++;
					var e : * = a[this.size() - 1 - i];
					acc = f(e,acc);
				}
			}
			return acc;
		}
		
		public function foldl(_tmp_z : *,_tmp_f : Function) : * {
			var z : * = _tmp_z, f : Function = _tmp_f;
			var acc : * = z;
			var cur : stx.ds.List = this;
			{
				var _g1 : int = 0, _g : int = this.size();
				while(_g1 < _g) {
					var i : int = _g1++;
					acc = f(acc,cur.getHead());
					cur = cur.getTail();
				}
			}
			return acc;
		}
		
		public function append(_tmp_b : *) : * {
			var b : * = _tmp_b;
			return this.add(b);
		}
		
		public function prependAllR(iterable : *) : stx.ds.List {
			var result : stx.ds.List = this;
			{ var $it : * = iterable.iterator();
			while( $it.hasNext() ) { var e : * = $it.next();
			result = result.cons(e);
			}}
			return result;
		}
		
		public function prependAll(iterable : *) : stx.ds.List {
			var result : stx.ds.List = this;
			var array : Array = Prelude.SIterables.toArray(iterable);
			array.reverse();
			{
				var _g : int = 0;
				while(_g < array.length) {
					var e : * = array[_g];
					++_g;
					result = result.cons(e);
				}
			}
			return result;
		}
		
		public function prepend(head : *) : stx.ds.List {
			return this.cons(head);
		}
		
		public function cons(head : *) : stx.ds.List {
			return new stx.ds._List.Cons(Prelude.tool(this._order,this._equal,this._hash,this._show),head,this);
		}
		
		public function empty() : stx.functional.Foldable {
			return stx.ds.List.nil();
		}
		
		public function get show() : Function { return getShow(); }
		protected function set show( __v : Function ) : void { $show = __v; }
		protected var $show : Function;
		public function get hash() : Function { return getHash(); }
		protected function set hash( __v : Function ) : void { $hash = __v; }
		protected var $hash : Function;
		public function get order() : Function { return getOrder(); }
		protected function set order( __v : Function ) : void { $order = __v; }
		protected var $order : Function;
		public function get equal() : Function { return getEqual(); }
		protected function set equal( __v : Function ) : void { $equal = __v; }
		protected var $equal : Function;
		public function get lastOption() : stx.Option { return getLastOption(); }
		protected function set lastOption( __v : stx.Option ) : void { $lastOption = __v; }
		protected var $lastOption : stx.Option;
		public function get firstOption() : stx.Option { return getHeadOption(); }
		protected function set firstOption( __v : stx.Option ) : void { $firstOption = __v; }
		protected var $firstOption : stx.Option;
		public function get headOption() : stx.Option { return getHeadOption(); }
		protected function set headOption( __v : stx.Option ) : void { $headOption = __v; }
		protected var $headOption : stx.Option;
		public function get last() : * { return getLast(); }
		protected function set last( __v : * ) : void { $last = __v; }
		protected var $last : *;
		public function get first() : * { return getHead(); }
		protected function set first( __v : * ) : void { $first = __v; }
		protected var $first : *;
		public function get tail() : stx.ds.List { return getTail(); }
		protected function set tail( __v : stx.ds.List ) : void { $tail = __v; }
		protected var $tail : stx.ds.List;
		public function get head() : * { return getHead(); }
		protected function set head( __v : * ) : void { $head = __v; }
		protected var $head : *;
		static public function toList(i : *) : stx.ds.List {
			return stx.ds.List.create().addAll(i);
		}
		
		static public function nil(order : Function = null,tools : * = null) : stx.ds.List {
			return new stx.ds._List.Nil(tools);
		}
		
		static public function create(tools : * = null) : stx.ds.List {
			return stx.ds.List.nil(null,tools);
		}
		
		static public function factory(tools : * = null) : Function {
			return function() : stx.ds.List {
				return stx.ds.List.create(tools);
			}
		}
		
	}
}
