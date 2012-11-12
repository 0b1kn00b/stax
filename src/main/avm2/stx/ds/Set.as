package stx.ds {
	import stx.ds.Map;
	import stx.functional.Foldable;
	import stx.Tuple2;
	import stx.functional.Foldables;
	import stx.plus.ArrayOrder;
	import stx.plus.ArrayShow;
	import stx.ds.Collection;
	import flash.Boot;
	public class Set implements stx.ds.Collection{
		public function Set(map : stx.ds.Map = null) : void { if( !flash.Boot.skip_constructor ) {
			this._map = map;
		}}
		
		public function getShow() : Function {
			return this._map.getKeyShow();
		}
		
		public function getHash() : Function {
			return this._map.getKeyHash();
		}
		
		public function getEqual() : Function {
			return this._map.getKeyEqual();
		}
		
		public function getOrder() : Function {
			return this._map.getKeyOrder();
		}
		
		public function size() : int {
			return this._map.size();
		}
		
		protected function copyWithMod(newMap : stx.ds.Map) : stx.ds.Set {
			return new stx.ds.Set(newMap);
		}
		
		public function withShowFunction(show : Function) : stx.ds.Set {
			var m : * = this._map;
			return stx.ds.Set.create(m._keyOrder,m._keyEqual,m._keyHash,show).addAll(this);
		}
		
		public function withHashFunction(hash : Function) : stx.ds.Set {
			var m : * = this._map;
			return stx.ds.Set.create(m._keyOrder,m._keyEqual,hash,m._keyShow).addAll(this);
		}
		
		public function withEqualFunction(equal : Function) : stx.ds.Set {
			var m : * = this._map;
			return stx.ds.Set.create(m._keyOrder,equal,m._keyHash,m._keyShow).addAll(this);
		}
		
		public function withOrderFunction(order : Function) : stx.ds.Set {
			var m : * = this._map;
			return stx.ds.Set.create(order,m._keyEqual,m._keyHash,m._keyShow).addAll(this);
		}
		
		public function toString() : String {
			return "Set " + stx.plus.ArrayShow.toStringWith(Prelude.SIterables.toArray(this),this.getShow());
		}
		
		public function hashCode() : int {
			var ha : Function = this.getHash();
			return this.foldl(393241,function(a : int,b : *) : int {
				return a * (ha(b) + 6151);
			});
		}
		
		public function compare(other : stx.ds.Set) : int {
			return stx.plus.ArrayOrder.compareWith(Prelude.SIterables.toArray(this),Prelude.SIterables.toArray(other),this.getOrder());
		}
		
		public function equals(other : stx.ds.Set) : Boolean {
			var all : stx.ds.Set = stx.functional.FoldableExtensions.concat(this,other);
			return all.size() == this.size() && all.size() == other.size();
		}
		
		public function iterator() : * {
			return stx.functional.FoldableExtensions.iterator(this);
		}
		
		public function removeAll(_tmp_it : *) : * {
			var it : * = _tmp_it;
			var set : stx.ds.Set = this;
			{ var $it : * = it.iterator();
			while( $it.hasNext() ) { var e : * = $it.next();
			set = set.remove(e);
			}}
			return set;
		}
		
		public function remove(_tmp_t : *) : * {
			var t : * = _tmp_t;
			return this.copyWithMod(this._map.removeByKey(t));
		}
		
		public function addAll(_tmp_it : *) : * {
			var it : * = _tmp_it;
			var set : stx.ds.Set = this;
			{ var $it : * = it.iterator();
			while( $it.hasNext() ) { var e : * = $it.next();
			set = set.add(e);
			}}
			return set;
		}
		
		public function add(_tmp_t : *) : * {
			var t : * = _tmp_t;
			return ((this.contains(t))?this:this.copyWithMod(this._map.set(t,t)));
		}
		
		public function foldl(_tmp_z : *,_tmp_f : Function) : * {
			var z : * = _tmp_z, f : Function = _tmp_f;
			var acc : * = z;
			{ var $it : * = this._map.iterator();
			while( $it.hasNext() ) { var e : stx.Tuple2 = $it.next();
			acc = f(acc,e._1);
			}}
			return acc;
		}
		
		public function append(_tmp_t : *) : * {
			var t : * = _tmp_t;
			return this.copyWithMod(this._map.set(t,t));
		}
		
		public function empty() : stx.functional.Foldable {
			return stx.ds.Set.create();
		}
		
		public function contains(_tmp_e : *) : Boolean {
			var e : * = _tmp_e;
			return this._map.containsKey(e);
		}
		
		protected var _map : stx.ds.Map;
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
		static public function toSet(i : *) : stx.ds.Set {
			return stx.ds.Set.create().addAll(i);
		}
		
		static public function create(order : Function = null,equal : Function = null,hash : Function = null,show : Function = null) : stx.ds.Set {
			return new stx.ds.Set(stx.ds.Map.create(order,equal,hash,show));
		}
		
		static public function factory(order : Function = null,equal : Function = null,hash : Function = null,show : Function = null) : Function {
			return function() : stx.ds.Set {
				return stx.ds.Set.create(order,equal,hash,show);
			}
		}
		
	}
}
