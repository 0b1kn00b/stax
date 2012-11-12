package stx.ds {
	import stx.ds.Collection;
	import stx.ds.Set;
	import stx.functional.PartialFunction1ImplExtensions;
	import stx.functional.PartialFunction1;
	import flash.Boot;
	import stx.plus.IterableShow;
	import stx.Option;
	import stx.Options;
	import stx.Tuple2;
	import stx.plus.Show;
	import stx.plus.Equal;
	import stx.functional.Foldable;
	import stx.plus.ArrayOrder;
	import stx.Iterables;
	import stx.plus.Hasher;
	import stx.plus.Order;
	import stx.Tuples;
	import stx.functional.Foldables;
	public class Map implements stx.functional.PartialFunction1, stx.ds.Collection{
		public function Map(korder : Function = null,kequal : Function = null,khash : Function = null,kshow : Function = null,vorder : Function = null,vequal : Function = null,vhash : Function = null,vshow : Function = null,buckets : Array = null,size : int = 0) : void { if( !flash.Boot.skip_constructor ) {
			var self : stx.ds.Map = this;
			this._keyOrder = korder;
			this._keyEqual = kequal;
			this._keyHash = khash;
			this._keyShow = kshow;
			this._valueOrder = vorder;
			this._valueEqual = vequal;
			this._valueHash = vhash;
			this._valueShow = vshow;
			this._size = size;
			this._buckets = buckets;
			this._pf = stx.functional.PartialFunction1ImplExtensions.toPartialFunction([stx.Tuples.t2(this.containsKey,function(k : *) : * {
				return function() : * {
					var $r : *;
					{
						var $e2 : enum = (self.get(k));
						switch( $e2.index ) {
						case 1:
						var v : * = $e2.params[0];
						$r = v;
						break;
						case 0:
						$r = Prelude.error("No value for this key",{ fileName : "Map.hx", lineNumber : 88, className : "stx.ds.Map", methodName : "new"});
						break;
						}
					}
					return $r;
				}();
			})]);
		}}
		
		public function getValueShow() : Function {
			return ((null == this._valueShow)?(function($this:Map) : Function {
				var $r : Function;
				var it : * = $this.iterator();
				$r = ((!it.hasNext())?stx.plus.Show.getShowFor(null):$this._valueShow = stx.plus.Show.getShowFor(it.next()._2));
				return $r;
			}(this)):this._valueShow);
		}
		
		public function getValueHash() : Function {
			return ((null == this._valueHash)?(function($this:Map) : Function {
				var $r : Function;
				var it : * = $this.iterator();
				$r = ((!it.hasNext())?stx.plus.Hasher.getHashFor(null):$this._valueHash = stx.plus.Hasher.getHashFor(it.next()._2));
				return $r;
			}(this)):this._valueHash);
		}
		
		public function getValueEqual() : Function {
			return ((null == this._valueEqual)?(function($this:Map) : Function {
				var $r : Function;
				var it : * = $this.iterator();
				$r = ((!it.hasNext())?stx.plus.Equal.getEqualFor(null):$this._valueEqual = stx.plus.Equal.getEqualFor(it.next()._2));
				return $r;
			}(this)):this._valueEqual);
		}
		
		public function getValueOrder() : Function {
			return ((null == this._valueOrder)?(function($this:Map) : Function {
				var $r : Function;
				var it : * = $this.iterator();
				$r = ((!it.hasNext())?stx.plus.Order.getOrderFor(null):$this._valueOrder = stx.plus.Order.getOrderFor(it.next()._2));
				return $r;
			}(this)):this._valueOrder);
		}
		
		public function getKeyShow() : Function {
			return ((null == this._keyShow)?(function($this:Map) : Function {
				var $r : Function;
				var it : * = $this.iterator();
				$r = ((!it.hasNext())?stx.plus.Show.getShowFor(null):$this._keyShow = stx.plus.Show.getShowFor(it.next()._1));
				return $r;
			}(this)):this._keyShow);
		}
		
		public function getKeyHash() : Function {
			return ((null == this._keyHash)?(function($this:Map) : Function {
				var $r : Function;
				var it : * = $this.iterator();
				$r = ((!it.hasNext())?stx.plus.Hasher.getHashFor(null):$this._keyHash = stx.plus.Hasher.getHashFor(it.next()._1));
				return $r;
			}(this)):this._keyHash);
		}
		
		public function getKeyEqual() : Function {
			return ((null == this._keyEqual)?(function($this:Map) : Function {
				var $r : Function;
				var it : * = $this.iterator();
				$r = ((!it.hasNext())?stx.plus.Equal.getEqualFor(null):$this._keyEqual = stx.plus.Equal.getEqualFor(it.next()._1));
				return $r;
			}(this)):this._keyEqual);
		}
		
		public function getKeyOrder() : Function {
			return ((null == this._keyOrder)?(function($this:Map) : Function {
				var $r : Function;
				var it : * = $this.iterator();
				$r = ((!it.hasNext())?stx.plus.Order.getOrderFor(null):$this._keyOrder = stx.plus.Order.getOrderFor(it.next()._1));
				return $r;
			}(this)):this._keyOrder);
		}
		
		protected var _valueShow : Function;
		protected var _valueHash : Function;
		protected var _valueOrder : Function;
		protected var _valueEqual : Function;
		protected var _keyShow : Function;
		protected var _keyHash : Function;
		protected var _keyOrder : Function;
		protected var _keyEqual : Function;
		public function size() : int {
			return this._size;
		}
		
		protected function listFor(k : *) : Array {
			return ((this._buckets.length == 0)?[]:this._buckets[this.bucketFor(k)]);
		}
		
		protected function bucketFor(k : *) : int {
			return (this.getKeyHash())(k) % this._buckets.length;
		}
		
		protected function rebalance() : void {
			var newSize : int = Math.round(this.size() / ((stx.ds.Map.MaxLoad + stx.ds.Map.MinLoad) / 2));
			if(newSize > 0) {
				var all : * = this.entries();
				this._buckets = [];
				{
					var _g : int = 0;
					while(_g < newSize) {
						var i : int = _g++;
						this._buckets.push([]);
					}
				}
				{ var $it : * = all.iterator();
				while( $it.hasNext() ) { var e : stx.Tuple2 = $it.next();
				{
					var bucket : int = this.bucketFor(e._1);
					this._buckets[bucket].push(e);
				}
				}}
			}
		}
		
		protected function copyWithMod(index : int) : stx.ds.Map {
			var newTable : Array = [];
			{
				var _g : int = 0;
				while(_g < index) {
					var i : int = _g++;
					newTable.push(this._buckets[i]);
				}
			}
			newTable.push([].concat(this._buckets[index]));
			{
				var _g1 : int = index + 1, _g2 : int = this._buckets.length;
				while(_g1 < _g2) {
					var i1 : int = _g1++;
					newTable.push(this._buckets[i1]);
				}
			}
			return new stx.ds.Map(this._keyOrder,this._keyEqual,this._keyHash,this._keyShow,this._valueOrder,this._valueEqual,this._valueHash,this._valueShow,newTable,this.size());
		}
		
		protected function removeInternal(k : *,v : *,ignoreValue : Boolean) : stx.ds.Map {
			var bucket : int = this.bucketFor(k);
			var list : Array = this._buckets[bucket];
			var ke : Function = this.getKeyEqual();
			var ve : Function = this.getValueEqual();
			{
				var _g1 : int = 0, _g : int = list.length;
				while(_g1 < _g) {
					var i : int = _g1++;
					var entry : stx.Tuple2 = list[i];
					if(ke(entry._1,k)) {
						if(ignoreValue || ve(entry._2,v)) {
							var newMap : stx.ds.Map = this.copyWithMod(bucket);
							newMap._buckets[bucket] = list.slice(0,i).concat(list.slice(i + 1,list.length));
							newMap._size -= 1;
							if(newMap.load() < stx.ds.Map.MinLoad) newMap.rebalance();
							return newMap;
						}
						else return this;
					}
				}
			}
			return this;
		}
		
		protected function entries() : * {
			var buckets : Array = this._buckets;
			var iterable : * = { iterator : function() : * {
				var bucket : int = 0, element : int = 0;
				var computeNextValue : Function = function() : stx.Option {
					while(bucket < buckets.length) if(element >= buckets[bucket].length) {
						element = 0;
						++bucket;
					}
					else return stx.Option.Some(buckets[bucket][element++]);
					return stx.Option.None;
				}
				var nextValue : stx.Option = computeNextValue();
				return { hasNext : function() : Boolean {
					return !stx.Options.isEmpty(nextValue);
				}, next : function() : stx.Tuple2 {
					var value : stx.Option = nextValue;
					nextValue = computeNextValue();
					return stx.Options.get(value);
				}}
			}}
			return iterable;
		}
		
		public function withValueShowFunction(show : Function) : stx.ds.Map {
			return stx.ds.Map.create(this._keyOrder,this._keyEqual,this._keyHash,this._keyShow,this._valueOrder,this._valueEqual,this._valueHash,show).addAll(this);
		}
		
		public function withValueHashFunction(hash : Function) : stx.ds.Map {
			return stx.ds.Map.create(this._keyOrder,this._keyEqual,this._keyHash,this._keyShow,this._valueOrder,this._valueEqual,hash,this._valueShow).addAll(this);
		}
		
		public function withValueEqualFunction(equal : Function) : stx.ds.Map {
			return stx.ds.Map.create(this._keyOrder,this._keyEqual,this._keyHash,this._keyShow,this._valueOrder,equal,this._valueHash,this._valueShow).addAll(this);
		}
		
		public function withValueOrderFunction(order : Function) : stx.ds.Map {
			return stx.ds.Map.create(this._keyOrder,this._keyEqual,this._keyHash,this._keyShow,order,this._valueEqual,this._valueHash,this._valueShow).addAll(this);
		}
		
		public function withKeyShowFunction(show : Function) : stx.ds.Map {
			return stx.ds.Map.create(this._keyOrder,this._keyEqual,this._keyHash,show,this._valueOrder,this._valueEqual,this._valueHash,this._valueShow).addAll(this);
		}
		
		public function withKeyHashFunction(hash : Function) : stx.ds.Map {
			return stx.ds.Map.create(this._keyOrder,this._keyEqual,hash,this._keyShow,this._valueOrder,this._valueEqual,this._valueHash,this._valueShow).addAll(this);
		}
		
		public function withKeyEqualFunction(equal : Function) : stx.ds.Map {
			return stx.ds.Map.create(this._keyOrder,equal,this._keyHash,this._keyShow,this._valueOrder,this._valueEqual,this._valueHash,this._valueShow).addAll(this);
		}
		
		public function withKeyOrderFunction(order : Function) : stx.ds.Map {
			return stx.ds.Map.create(order,this._keyEqual,this._keyHash,this._keyShow,this._valueOrder,this._valueEqual,this._valueHash,this._valueShow).addAll(this);
		}
		
		public function load() : int {
			return ((this._buckets.length == 0)?stx.ds.Map.MaxLoad:Math.round(this.size() / this._buckets.length));
		}
		
		public function hashCode() : int {
			var kha : Function = this.getKeyHash();
			var vha : Function = this.getValueHash();
			return this.foldl(786433,function(a : int,b : stx.Tuple2) : int {
				return a + (kha(b._1) * 49157 + 6151) * vha(b._2);
			});
		}
		
		public function toString() : String {
			var ksh : Function = this.getKeyShow();
			var vsh : Function = this.getValueShow();
			return "Map " + stx.plus.IterableShow.toString(stx.Iterables.elements(this),function(t : stx.Tuple2) : String {
				return ksh(t._1) + " -> " + vsh(t._2);
			});
		}
		
		public function equals(other : stx.ds.Map) : Boolean {
			var keys1 : stx.ds.Set = this.keySet();
			var keys2 : stx.ds.Set = other.keySet();
			if(!keys1.equals(keys2)) return false;
			var ve : Function = this.getValueEqual();
			{ var $it : * = keys1.iterator();
			while( $it.hasNext() ) { var key : * = $it.next();
			{
				var v1 : * = stx.Options.get(this.get(key));
				var v2 : * = stx.Options.get(other.get(key));
				if(!ve(v1,v2)) return false;
			}
			}}
			return true;
		}
		
		public function compare(other : stx.ds.Map) : int {
			var a1 : Array = Prelude.SIterables.toArray(this);
			var a2 : Array = Prelude.SIterables.toArray(other);
			var ko : Function = this.getKeyOrder();
			var vo : Function = this.getValueOrder();
			var sorter : Function = function(t1 : stx.Tuple2,t2 : stx.Tuple2) : int {
				var c : int = ko(t1._1,t2._1);
				return ((c != 0)?c:vo(t1._2,t2._2));
			}
			a1.sort(sorter);
			a2.sort(sorter);
			return stx.plus.ArrayOrder.compare(a1,a2);
		}
		
		public function iterator() : * {
			return stx.functional.FoldableExtensions.iterator(this);
		}
		
		public function values() : * {
			var self : stx.ds.Map = this;
			return { iterator : function() : * {
				var entryIterator : * = self.entries().iterator();
				return { hasNext : entryIterator.hasNext, next : function() : * {
					return entryIterator.next()._2;
				}}
			}}
		}
		
		public function keySet() : stx.ds.Set {
			return stx.ds.Set.create(this._keyOrder,this._keyEqual,this._keyHash,this._keyShow).addAll(this.keys());
		}
		
		public function keys() : * {
			var self : stx.ds.Map = this;
			return { iterator : function() : * {
				var entryIterator : * = self.entries().iterator();
				return { hasNext : entryIterator.hasNext, next : function() : * {
					return entryIterator.next()._1;
				}}
			}}
		}
		
		public function containsKey(k : *) : Boolean {
			return (function($this:Map) : Boolean {
				var $r : Boolean;
				{
					var $e2 : enum = ($this.get(k));
					switch( $e2.index ) {
					case 0:
					$r = false;
					break;
					case 1:
					var v : * = $e2.params[0];
					$r = true;
					break;
					}
				}
				return $r;
			}(this));
		}
		
		public function contains(_tmp_t : *) : Boolean {
			var t : stx.Tuple2 = _tmp_t;
			var ke : Function = this.getKeyEqual();
			var ve : Function = this.getValueEqual();
			{ var $it : * = this.entries().iterator();
			while( $it.hasNext() ) { var e : stx.Tuple2 = $it.next();
			if(ke(e._1,t._1) && ve(t._2,t._2)) return true;
			}}
			return false;
		}
		
		public function getOrElseC(k : *,c : *) : * {
			return (function($this:Map) : * {
				var $r : *;
				{
					var $e2 : enum = ($this.get(k));
					switch( $e2.index ) {
					case 1:
					var v : * = $e2.params[0];
					$r = v;
					break;
					case 0:
					$r = c;
					break;
					}
				}
				return $r;
			}(this));
		}
		
		public function getOrElse(k : *,def : Function) : * {
			return (function($this:Map) : * {
				var $r : *;
				{
					var $e2 : enum = ($this.get(k));
					switch( $e2.index ) {
					case 1:
					var v : * = $e2.params[0];
					$r = v;
					break;
					case 0:
					$r = def();
					break;
					}
				}
				return $r;
			}(this));
		}
		
		public function get(k : *) : stx.Option {
			var ke : Function = this.getKeyEqual();
			{
				var _g : int = 0, _g1 : Array = this.listFor(k);
				while(_g < _g1.length) {
					var e : stx.Tuple2 = _g1[_g];
					++_g;
					if(ke(e._1,k)) return stx.Option.Some(e._2);
				}
			}
			return stx.Option.None;
		}
		
		public function removeAllByKey(i : *) : stx.ds.Map {
			var map : stx.ds.Map = this;
			{ var $it : * = i.iterator();
			while( $it.hasNext() ) { var k : * = $it.next();
			map = map.removeByKey(k);
			}}
			return map;
		}
		
		public function removeByKey(k : *) : stx.ds.Map {
			return this.removeInternal(k,null,true);
		}
		
		public function removeAll(_tmp_i : *) : * {
			var i : * = _tmp_i;
			var map : stx.ds.Map = this;
			{ var $it : * = i.iterator();
			while( $it.hasNext() ) { var t : stx.Tuple2 = $it.next();
			map = map.remove(t);
			}}
			return map;
		}
		
		public function remove(_tmp_t : *) : * {
			var t : stx.Tuple2 = _tmp_t;
			return this.removeInternal(t._1,t._2,false);
		}
		
		public function addAll(_tmp_i : *) : * {
			var i : * = _tmp_i;
			var map : stx.ds.Map = this;
			{ var $it : * = i.iterator();
			while( $it.hasNext() ) { var t : stx.Tuple2 = $it.next();
			map = map.add(t);
			}}
			return map;
		}
		
		public function add(_tmp_t : *) : * {
			var t : stx.Tuple2 = _tmp_t;
			var k : * = t._1;
			var v : * = t._2;
			var bucket : int = this.bucketFor(k);
			var list : Array = this._buckets[bucket];
			if(null == this._keyEqual) this._keyEqual = stx.plus.Equal.getEqualFor(t._1);
			if(null == this._valueEqual) this._valueEqual = stx.plus.Equal.getEqualFor(t._2);
			{
				var _g1 : int = 0, _g : int = list.length;
				while(_g1 < _g) {
					var i : int = _g1++;
					var entry : stx.Tuple2 = list[i];
					if((this._keyEqual)(entry._1,k)) {
						if(!(this._valueEqual)(entry._2,v)) {
							var newMap : stx.ds.Map = this.copyWithMod(bucket);
							newMap._buckets[bucket][i] = t;
							return newMap;
						}
						else return this;
					}
				}
			}
			var newMap1 : stx.ds.Map = this.copyWithMod(bucket);
			newMap1._buckets[bucket].push(t);
			newMap1._size += 1;
			if(newMap1.load() > stx.ds.Map.MaxLoad) newMap1.rebalance();
			return newMap1;
		}
		
		public function set(k : *,v : *) : stx.ds.Map {
			return this.add(stx.Tuples.t2(k,v));
		}
		
		public function foldl(_tmp_z : *,_tmp_f : Function) : * {
			var z : * = _tmp_z, f : Function = _tmp_f;
			var acc : * = z;
			{ var $it : * = this.entries().iterator();
			while( $it.hasNext() ) { var e : stx.Tuple2 = $it.next();
			acc = f(acc,e);
			}}
			return acc;
		}
		
		public function append(_tmp_t : *) : * {
			var t : stx.Tuple2 = _tmp_t;
			return this.add(t);
		}
		
		public function empty() : stx.functional.Foldable {
			return stx.ds.Map.create();
		}
		
		public function toFunction() : Function {
			return this.get;
		}
		
		public function call(_tmp_k : *) : * {
			var k : * = _tmp_k;
			return this._pf.call(k);
		}
		
		public function orAlwaysC(_tmp_v : Function) : stx.functional.PartialFunction1 {
			var v : Function = _tmp_v;
			return this._pf.orAlwaysC(v);
		}
		
		public function orAlways(_tmp_f : Function) : stx.functional.PartialFunction1 {
			var f : Function = _tmp_f;
			return this._pf.orAlways(f);
		}
		
		public function orElse(_tmp_that : stx.functional.PartialFunction1) : stx.functional.PartialFunction1 {
			var that : stx.functional.PartialFunction1 = _tmp_that;
			return this._pf.orElse(that);
		}
		
		public function isDefinedAt(_tmp_k : *) : Boolean {
			var k : * = _tmp_k;
			return this._pf.isDefinedAt(k);
		}
		
		protected var _pf : stx.functional.PartialFunction1;
		protected var _size : int;
		protected var _buckets : Array;
		public function get valueShow() : Function { return getValueShow(); }
		protected function set valueShow( __v : Function ) : void { $valueShow = __v; }
		protected var $valueShow : Function;
		public function get valueHash() : Function { return getValueHash(); }
		protected function set valueHash( __v : Function ) : void { $valueHash = __v; }
		protected var $valueHash : Function;
		public function get valueOrder() : Function { return getValueOrder(); }
		protected function set valueOrder( __v : Function ) : void { $valueOrder = __v; }
		protected var $valueOrder : Function;
		public function get valueEqual() : Function { return getValueEqual(); }
		protected function set valueEqual( __v : Function ) : void { $valueEqual = __v; }
		protected var $valueEqual : Function;
		public function get keyShow() : Function { return getKeyShow(); }
		protected function set keyShow( __v : Function ) : void { $keyShow = __v; }
		protected var $keyShow : Function;
		public function get keyHash() : Function { return getKeyHash(); }
		protected function set keyHash( __v : Function ) : void { $keyHash = __v; }
		protected var $keyHash : Function;
		public function get keyOrder() : Function { return getKeyOrder(); }
		protected function set keyOrder( __v : Function ) : void { $keyOrder = __v; }
		protected var $keyOrder : Function;
		public function get keyEqual() : Function { return getKeyEqual(); }
		protected function set keyEqual( __v : Function ) : void { $keyEqual = __v; }
		protected var $keyEqual : Function;
		static public var MaxLoad : int = 10;
		static public var MinLoad : int = 1;
		static public function create(korder : Function = null,kequal : Function = null,khash : Function = null,kshow : Function = null,vorder : Function = null,vequal : Function = null,vhash : Function = null,vshow : Function = null) : stx.ds.Map {
			return new stx.ds.Map(korder,kequal,khash,kshow,vorder,vequal,vhash,vshow,[[]],0);
		}
		
		static public function factory(korder : Function = null,kequal : Function = null,khash : Function = null,kshow : Function = null,vorder : Function = null,vequal : Function = null,vhash : Function = null,vshow : Function = null) : Function {
			return function() : stx.ds.Map {
				return stx.ds.Map.create(korder,kequal,khash,kshow,vorder,vequal,vhash,vshow);
			}
		}
		
	}
}
