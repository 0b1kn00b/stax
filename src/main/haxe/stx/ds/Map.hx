/*
 HaXe library written by John A. De Goes <john@socialmedia.com>
 Contributed by Social Media Networks

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the
 distribution.

 THIS SOFTWARE IS PROVIDED BY SOCIAL MEDIA NETWORKS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL SOCIAL MEDIA NETWORKS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package stx.ds;


using stx.Prelude;

import stx.Tuples;
import stx.Prelude;

using stx.Bools;

import stx.functional.Foldable;
import stx.functional.PartialFunction;
import stx.ds.Collection;
import stx.functional.Foldables;

using stx.Options;
using stx.Functions;

import stx.plus.Order; 
import stx.plus.Hasher;
import stx.plus.Show;
import stx.plus.Equal;

using stx.Iterables;

using stx.functional.Foldables;
using stx.functional.PartialFunctions;

/** A cross-platform, immutable map with support for arbitrary keys.
 * TODO: Use an array of lists to avoid unnecessary copying when adding/removing elements.
 */
class Map<K, V> implements Collection<Map<K, V>, Tuple2<K, V>>, implements PartialFunction<K, V> {
  public static var MaxLoad = 10;
  public static var MinLoad = 1;

  
  public var keyOrder(getKeyOrder,null)      : OrderFunction<K>;
  private function getKeyOrder(){
    return 
      if (keyOrder == null || keyOrder == Order.nil ){
          keys().headOption().map( Order.getOrderFor )
          .foreach( function(x) keyOrder = x)
          .getOrElseC( Order.getOrderFor(null) );
      }else{
        keyOrder;
      }
  }

  public var valueOrder    : OrderFunction<V>;
  private function getValueOrder(){
    return 
      if (valueOrder == null || valueOrder == Order.nil){
          values().headOption().map( Order.getOrderFor )
          .foreach( function(x) valueOrder = x)
          .getOrElseC( Order.getOrderFor(null) );
      }else{
        valueOrder;
      }
  }

  public var keyHash(getKeyHash,null)       : HashFunction<K>;
  private function getKeyHash(){
    return 
      if (keyHash == null || keyHash == Hasher.nil){
        keys().headOption()
          .map( Hasher.getHashFor )
          .foreach( function(x) keyHash = x)
          .getOrElseC( Hasher.getHashFor(null) );
      }else{
        keyHash;
      }
  }
  public var valueHash(getValueHash,null)     : HashFunction<V>;
  private function getValueHash(){
    return 
      if (valueHash == null || valueHash == Hasher.nil){
        values().headOption()
          .map( Hasher.getHashFor )
          .foreach( function(x) valueHash = x)
          .getOrElseC( Hasher.getHashFor(null) );
      }else{
        valueHash;
      }
  }

  public var keyShow(getKeyShow,null)       : ShowFunction<K>;
  private function getKeyShow(){
    return 
      if (keyShow == null || keyShow == Show.nil){
        keys().headOption()
          .map( Show.getShowFor )
          .foreach( function(x) keyShow = x)
          .getOrElseC( Show.getShowFor(null) );
      }else{
        keyShow;
      }
  }
  public var valueShow(getValueShow,null)   : ShowFunction<V>;
  private function getValueShow(){
    return 
      if (valueShow == null || valueShow == Show.nil){
        values().headOption()
          .map( Show.getShowFor )
          .foreach( function(x) valueShow = x)
          .getOrElseC( Show.getShowFor(null) );
      }else{
        valueShow;
      }
  }
  public var keyEqual(getKeyEqual,null)     : EqualFunction<K>;
  private function getKeyEqual(){
    return 
      if (keyEqual == null || keyEqual == Equal.nil){
          keys().headOption().map( Equal.getEqualFor )
          .foreach( function(x){ keyEqual = x;})
          .getOrElseC( Equal.getEqualFor(null) );
      }else{
        keyEqual;
      }
  }
  public var valueEqual(getValueEqual,null)    : EqualFunction<V>;
  private function getValueEqual(){
    return 
      if (valueEqual == null || valueEqual == Equal.nil ){
          values().headOption().map( Equal.getEqualFor )
          .foreach( function(x) valueEqual = x)
          .getOrElseC( Equal.getEqualFor(null) );
      }else{
        valueEqual;
      }
  }
  
  var _buckets: Array<Array<Tuple2<K, V>>>;
  
  var _size: Int;
  var _pf: PartialFunction1<K, V>;
    
  public static function create<K, V>(?korder : OrderFunction<K>, ?kequal: EqualFunction<K>, ?khash: HashFunction<K>, ?kshow : ShowFunction<K>, ?vorder : OrderFunction<V>, ?vequal: EqualFunction<V>, ?vhash: HashFunction<V>, ?vshow : ShowFunction<V>) {
    return new Map<K, V>(korder, kequal, khash, kshow, vorder, vequal, vhash, vshow, [[]], 0);
  }
  
  /** Creates a factory for maps of the specified types. */
  public static function factory<K, V>(?korder : OrderFunction<K>, ?kequal: EqualFunction<K>, ?khash: HashFunction<K>, ?kshow : ShowFunction<K>, ?vorder : OrderFunction<V>, ?vequal: EqualFunction<V>, ?vhash: HashFunction<V>, ?vshow : ShowFunction<V>): Factory<Map<K, V>> {
    return function() {
      return Map.create(korder, kequal, khash, kshow, vorder, vequal, vhash, vshow);
    }
  }
  
  private function new(korder : OrderFunction<K>, kequal: EqualFunction<K>, khash: HashFunction<K>, kshow : ShowFunction<K>, vorder : OrderFunction<V>, vequal: EqualFunction<V>, vhash: HashFunction<V>, vshow : ShowFunction<V>, buckets: Array<Array<Tuple2<K, V>>>, size: Int) {
    var self = this;
    
    this.keyOrder    = korder;
    this.keyEqual    = kequal; 
    this.keyHash     = khash; 
    this.keyShow     = kshow; 
    this.valueOrder  = vorder;  
    this.valueEqual  = vequal; 
    this.valueHash   = vhash; 
    this.valueShow   = vshow;
    

    this._size     = size;
    this._buckets  = buckets;
    this._pf       = [stx.Tuples.t2(
      containsKey,
      function(k) {
        return switch(self.get(k)) {
          case Some(v): v;
          case None:    Prelude.error("No value for this key");
        }
      }
    )].toPartialFunction();
  }
  
  public function isDefinedAt(k: K): Bool {
    return _pf.isDefinedAt(k);
  }
  
  public function orElse(that: PartialFunction1<K, V>): PartialFunction1<K, V> {
    return _pf.orElse(that);
  }
  
  public function orAlways(f: K -> V): PartialFunction1<K, V> {
    return _pf.orAlways(f);
  }
  
  public function orAlwaysC(v: Thunk<V>): PartialFunction1<K, V> {
    return _pf.orAlwaysC(v);
  }
  
  public function call(k: K): V {
    return _pf.call(k);
  }
    
  public function toFunction(): K -> Option<V> {
    return get;
  }
  
  public function empty<C, D>(): Foldable<C, D> {
    return cast create();
  }
  
  public function append(t: Tuple2<K, V>): Map<K, V> {
    return add(t);
  }
  
  public function foldl<Z>(z: Z, f: Z -> Tuple2<K, V> -> Z): Z {
    var acc = z;
    
    for (e in entries()) {
      acc = f(acc, e);
    }
    
    return acc;
  }
  
  public function set(k: K, v: V): Map<K, V> {
    return add(stx.Tuples.t2(k, v));
  }
  
  public function add(t: Tuple2<K, V>): Map<K, V> {
    
    var key   : K   = t._1;
    var value : V   = t._2;
    var bucket  = bucketFor(key);
    
    var list = _buckets[bucket];  
    

    for (i in 0...list.length) {
      var entry = list[i];

      if (keyEqual(entry._1, key)) {
        if (!valueEqual(entry._2, value)) {
          var newMap = copyWithMod(bucket);
          newMap._buckets[bucket][i] = t;
                  
          return newMap;
        }
        else {
          return this;
        }
      }
    }
    
    var newMap = copyWithMod(bucket);
    
    newMap._buckets[bucket].push(t);
    
    newMap._size += 1;
    
    if (newMap.load() > MaxLoad) {
      newMap.rebalance();
    }
    
    return newMap;
  }
  
  public function addAll(i: Iterable<Tuple2<K, V>>): Map<K, V> {
    var map = this;
    
    for (t in i) map = map.add(t);
    
    return map;
  }

  public function remove(t: Tuple2<K, V>): Map<K, V> {
    return removeInternal(t._1, t._2, false);
  }
  
  public function removeAll(i: Iterable<Tuple2<K, V>>): Map<K, V> {
    var map = this;
    
    for (t in i) map = map.remove(t);
    
    return map;
  }
  
  public function removeByKey(k: K): Map<K, V> {
    return removeInternal(k, null, true);
  }

  public function removeAllByKey(i: Iterable<K>): Map<K, V> {
    var map = this;
    
    for (k in i) map = map.removeByKey(k);
    
    return map;
  }

  public function get(k: K): Option<V> {  

    for (e in listFor(k)) {
      if (keyEqual(e._1, k)) {
        return Some(e._2);
      }
    }
    return None;
  }
  
  public function getOrElse(k: K, def: Thunk<V>): V {
    return switch (get(k)) {
      case Some(v): v;
      case None: def();
    }
  }
  
  public function getOrElseC(k: K, c: V): V {
    return switch (get(k)) {
      case Some(v): v;
      case None: c;
    }
  }
  
  public function contains(t: Tuple2<K, V>): Bool {      
    for (e in entries()) {
      if (keyEqual(e._1, t._1) && valueEqual(t._2, t._2)) return true;
    }
    
    return false;
  }
  
  public function containsKey(k: K): Bool {
    return switch(get(k)) {
      case None:    false;
      case Some(v): true;
    }
  }
  
  public function keys(): Iterable<K> {
    var self = this;
    
    return {
      iterator: function() {
        var entryIterator = self.entries().iterator();
        
        return {
          hasNext: entryIterator.hasNext,
          
          next: function() {
            return entryIterator.next()._1;
          }
        }
      }
    }
  }
  
  public function keySet(): Set<K> {
    return Set.create(keyOrder, keyEqual, keyHash, keyShow).addAll(keys());
  }
  
  public function values(): Iterable<V> {
    var self = this;
    
    return {
      iterator: function() {
        var entryIterator = self.entries().iterator();
        
        return {
          hasNext: entryIterator.hasNext,
          
          next: function() {
            return entryIterator.next()._2;
          }
        }
      }
    }
  }

  public function iterator(): Iterator<Tuple2<K, V>> {
    return Foldables.iterator(this);
  }

  public function compare(other : Map<K, V>) {
    var a1 = this.toArray();
    var a2 = other.toArray(); 
    
    var sorter = function(t1: Tuple2<K, V>, t2: Tuple2<K, V>): Int {
      var c = keyOrder(t1._1, t2._1);
      return if(c != 0)
        c;
      else
        valueOrder(t1._2, t2._2);
    }
    
    a1.sort(sorter);
    a2.sort(sorter);

    return ArrayOrder.compare(a1,a2);
  } 

  public function equals(other : Map<K, V>) {
    var keys1 = this.keySet();
    var keys2 = other.keySet();

    if(!keys1.equals(keys2)) return false;

    for(key in keys1) {
      var v1 = this.get(key).get();
      var v2 = other.get(key).get();
      if (!valueEqual(v1, v2)) return false;
    }
    return true;
  }

  public function toString() { 
    return "Map " + 
      IterableShow.toString(entries(),
        function(t:Tuple2<K,V>):String{ 
          return keyShow(t._1) + " -> " + valueShow(t._2); 
        }
      );  
  }

  public function hashCode() {
    return foldl(786433, function(a, b) return a + (keyHash(b._1) * 49157 + 6151) * valueHash(b._2));
  }

  public function load(): Int {
    return if (_buckets.length == 0) MaxLoad;
           else Math.round(this.size() / _buckets.length);
  }

  public function withKeyOrderFunction(order : OrderFunction<K>) {
    return create(order, keyEqual, keyHash, keyShow, valueOrder, valueEqual, valueHash, valueShow).addAll(this);
  }

  public function withKeyEqualFunction(equal : EqualFunction<K>) {
    return create(keyOrder, equal, keyHash, keyShow, valueOrder, valueEqual, valueHash, valueShow).addAll(this);
  }

  public function withKeyHashFunction(hash : HashFunction<K>) {
    return create(keyOrder, keyEqual, hash, keyShow, valueOrder, valueEqual, valueHash, valueShow).addAll(this);
  }

  public function withKeyShowFunction(show : ShowFunction<K>) { 
    return create(keyOrder, keyEqual, keyHash, show, valueOrder, valueEqual, valueHash, valueShow).addAll(this);
  }

  public function withValueOrderFunction(order : OrderFunction<V>) {
    return create(keyOrder, keyEqual, keyHash, keyShow, order, valueEqual, valueHash, valueShow).addAll(this);
  }

  public function withValueEqualFunction(equal : EqualFunction<V>) {
    return create(keyOrder, keyEqual, keyHash, keyShow, valueOrder, equal, valueHash, valueShow).addAll(this);
  }

  public function withValueHashFunction(hash : HashFunction<V>) {
    return create(keyOrder, keyEqual, keyHash, keyShow, valueOrder, valueEqual, hash, valueShow).addAll(this);
  }

  public function withValueShowFunction(show : ShowFunction<V>) { 
    return create(keyOrder, keyEqual, keyHash, keyShow, valueOrder, valueEqual, valueHash, show).addAll(this);
  }

  private function entries(): Iterable<Tuple2<K, V>> {
    var buckets = _buckets;
    
    var iterable: Iterable<Tuple2<K, V>> = {
      iterator: function(): Iterator<Tuple2<K, V>> {
        var bucket = 0, element = 0;
        
        var computeNextValue = function(): Option<Tuple2<K, V>> {
          while (bucket < buckets.length) {
            if (element >= buckets[bucket].length) {
              element = 0;
              ++bucket;
            }
            else {
              return Some(buckets[bucket][element++]);
            }
          }
          
          return None;
        }
        
        var nextValue = computeNextValue();
        
        return {
          hasNext: function(): Bool {
            return !nextValue.isEmpty();
          },
          
          next: function(): Tuple2<K, V> {
            var value = nextValue;
            
            nextValue = computeNextValue();
            
            return value.get();
          }
        }
      }
    }
    
    return iterable;
  }

  private function removeInternal(k: K, v: V, ignoreValue: Bool): Map<K, V> {
    var bucket = bucketFor(k);
    
    var list = _buckets[bucket];  
    
    var ke = keyEqual;
    var ve = valueEqual;
    
    for (i in 0...list.length) {
      var entry = list[i];
      
      if (ke(entry._1, k)) {
        if (ignoreValue || ve(entry._2, v)) {
          var newMap = copyWithMod(bucket);
        
          newMap._buckets[bucket] = list.slice(0, i).concat(list.slice(i + 1, list.length));
          newMap._size -= 1;
        
          if (newMap.load() < MinLoad) {
            newMap.rebalance();
          }
        
          return newMap;
        }
        else {
          return this;
        }
      }
    }   
    return this;
  }

  private function copyWithMod(index: Int): Map<K, V> {
    var newTable = [];
    
    for (i in 0...index) {
      newTable.push(_buckets[i]);
    }
    
    newTable.push([].concat(_buckets[index]));
    
    for (i in (index + 1)..._buckets.length) {
      newTable.push(_buckets[i]);
    }
    
    return new Map<K, V>(keyOrder, keyEqual, keyHash, keyShow, valueOrder, valueEqual, valueHash, valueShow, newTable, size());      
  }

  private function rebalance(): Void {
    var newSize = Math.round(size() / ((MaxLoad + MinLoad) / 2));
    
    if (newSize > 0) {
      var all = entries();
    
      _buckets = [];
    
      for (i in 0...newSize) {
        _buckets.push([]);
      }
    
      for (e in all) {
        var bucket = bucketFor(e._1);
      
        _buckets[bucket].push(e);
      }
    }
  }

  private function bucketFor(k: K): Int {
    return keyHash(k) % _buckets.length;
  }

  private function listFor(k: K): Array<Tuple2<K, V>> {
    return if (_buckets.length == 0) []
    else _buckets[bucketFor(k)];
  }

  public function size(): Int {
    return _size;
  }
}
class IterableToMap {
  public static function toMap<K, V>(i: Iterable<Tuple2<K, V>>):Map<K,V> {
    return stx.ds.Map.create().addAll(i);
  }	
}
class FoldableToMap {
	public static function toMap<A, K, V>(foldable : Foldable<A, Tuple2<K, V>>) : Map<K, V> {  
    var dest = Map.create();
    return foldable.foldl(dest, function(a, b) {
      return a.append(b);
    });
  }	
}
class ArrayToMap {
  public static function toMap<K, V>(arr : Array<Tuple2<K, V>>) {
    return stx.ds.Map.create().addAll(arr);
  }	
}
class MapExtensions {
  public static function toObject<V>(map: Map<String, V>): Dynamic<V> {
    return map.foldl({}, function(object, tuple) {
      Reflect.setField(object, tuple._1, tuple._2);
      
      return object;
    });
  }
  public static function toMap<T>(d: Dynamic<T>): Map<String, T> {
    var map: Map<String, T> = Map.create();
    
    for (field in Reflect.fields(d)) {
      var value = Reflect.field(d, field);
      
      map = map.set(field, value);
    }
    
    return map;
  }
}