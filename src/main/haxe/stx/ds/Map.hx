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

import stx.Tuples.*;
using stx.Prelude;

using stx.Tuples;
import stx.Prelude;

using stx.Bools;

import stx.functional.Foldable;
using stx.PartialFunctions;
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

class Map<K, V> implements Collection<Map<K, V>, Tuple2<K, V>> {
  public static var MaxLoad = 10;
  public static var MinLoad = 1;

  
  public var keyOrder(get_keyOrder,null)      : OrderFunction<K>;
  private function get_keyOrder(){
    return 
      if (keyOrder == null || keyOrder == Order.nil ){
          keys().headOption().map( Order.getOrderFor )
          .foreach( function(x) keyOrder = x)
          .getOrElseC( Order.getOrderFor(null) );
      }else{
        keyOrder;
      }
  }

  public var valueOrder(get_valueOrder,null)   : OrderFunction<V>;
  private function get_valueOrder(){
    //trace('value_order');
    return 
      if (valueOrder == null || valueOrder == Order.nil){
          values().headOption().map( Order.getOrderFor )
          .foreach( function(x) valueOrder = x)
          .getOrElseC( Order.getOrderFor(null) );
      }else{
        valueOrder;
      }
  }

  public var keyMap(get_keyMap,null)       : MapFunction<K>;
  private function get_keyMap(){
    return 
      if (keyMap == null || keyMap == Hasher.nil){
        keys().headOption()
          .map( Hasher.getHashFor )
          .foreach( function(x) keyMap = x)
          .getOrElseC( Hasher.getHashFor(null) );
      }else{
        keyMap;
      }
  }
  public var valueMap(get_valueMap,null)     : MapFunction<V>;
  private function get_valueMap(){
    return 
      if (valueMap == null || valueMap == Hasher.nil){
        values().headOption()
          .map( Hasher.getHashFor )
          .foreach( function(x) valueMap = x)
          .getOrElseC( Hasher.getHashFor(null) );
      }else{
        valueMap;
      }
  }

  public var keyShow(get_keyShow,null)       : ShowFunction<K>;
  private function get_keyShow(){
    return 
      if (keyShow == null || keyShow == NullShow.toString){
        keys().headOption()
          .map( Show.getShowFor )
          .foreach( function(x) keyShow = x)
          .getOrElseC( Show.getShowFor(null) );
      }else{
        keyShow;
      }
  }
  public var valueShow(get_valueShow,null)   : ShowFunction<V>;
  private function get_valueShow(){
    return 
      if (valueShow == null || valueShow == NullShow.toString){
        values().headOption()
          .map( Show.getShowFor )
          .foreach( function(x) valueShow = x)
          .getOrElseC( Show.getShowFor(null) );
      }else{
        valueShow;
      }
  }
  public var keyEqual(get_keyEqual,null)     : EqualFunction<K>;
  private function get_keyEqual(){
    return 
      if (keyEqual == null || keyEqual == NullEqual.equals){
          keys().headOption().map( Equal.getEqualFor )
          .foreach( function(x){ keyEqual = x;})
          .getOrElseC( Equal.getEqualFor(null) );
      }else{
        keyEqual;
      }
  }
  public var valueEqual(get_valueEqual,null)    : EqualFunction<V>;
  private function get_valueEqual(){
    return 
      if (valueEqual == null || valueEqual == NullEqual.equals ){
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
    
  public static function create<K, V>(?korder : OrderFunction<K>, ?kequal: EqualFunction<K>, ?khash: MapFunction<K>, ?kshow : ShowFunction<K>, ?vorder : OrderFunction<V>, ?vequal: EqualFunction<V>, ?vhash: MapFunction<V>, ?vshow : ShowFunction<V>) {
    return new Map<K, V>(korder, kequal, khash, kshow, vorder, vequal, vhash, vshow, [[]], 0);
  }
  
  /** Creates a factory for maps of the specified types. */
  public static function factory<K, V>(?korder : OrderFunction<K>, ?kequal: EqualFunction<K>, ?khash: MapFunction<K>, ?kshow : ShowFunction<K>, ?vorder : OrderFunction<V>, ?vequal: EqualFunction<V>, ?vhash: MapFunction<V>, ?vshow : ShowFunction<V>): Factory<Map<K, V>> {
    return function() {
      return Map.create(korder, kequal, khash, kshow, vorder, vequal, vhash, vshow);
    }
  }
  
  private function new(korder : OrderFunction<K>, kequal: EqualFunction<K>, khash: MapFunction<K>, kshow : ShowFunction<K>, vorder : OrderFunction<V>, vequal: EqualFunction<V>, vhash: MapFunction<V>, vshow : ShowFunction<V>, buckets: Array<Array<Tuple2<K, V>>>, size: Int) {
    var self = this;
    
    this.keyOrder    = korder;
    this.keyEqual    = kequal; 
    this.keyMap     = khash; 
    this.keyShow     = kshow; 
    this.valueOrder  = vorder;  
    this.valueEqual  = vequal; 
    this.valueMap   = vhash; 
    this.valueShow   = vshow;
    

    this._size     = size;
    this._buckets  = buckets;
    this._pf       = [tuple2(
      containsKey,
      function(k) {
        return switch(self.get(k)) {
          case Some(v): v;
          case None:    Prelude.error()("No value for this key");
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
  
  public function apply(k: K): V {
    return _pf.apply(k);
  }
    
  public function toFunction(): K -> Option<V> {
    return get;
  }
  
  public function unit<C, D>(): Foldable<C, D> {
    return cast create();
  }
  
  public function foldl<Z>(z: Z, f: Z -> Tuple2<K, V> -> Z): Z {
    var acc = z;
    
    for (e in entries()) {
      acc = f(acc, e);
    }
    
    return acc;
  }
  
  public function set(k: K, v: V): Map<K, V> {
    return add(tuple2(k, v));
  }
  
  public function add(t: Tuple2<K, V>): Map<K, V> {
    //trace('add $t');
    var key   : K   = t.fst();
    var value : V   = t.snd();
    var bucket  = bucketFor(key);
    
    var list = _buckets[bucket];  

    for (i in 0...list.length) {
      var entry = list[i];

      if (keyEqual(entry.fst(), key)) {
        if (!valueEqual(entry.snd(), value)) {
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
  
  public function append(i: Iterable<Tuple2<K, V>>): Map<K, V> {
    var map = this;

    for (t in i) map = map.add(t);
    
    return map;
  }

  public function remove(t: Tuple2<K, V>): Map<K, V> {
    return removeInternal(t.fst(), t.snd(), false);
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
      if (keyEqual(e.fst(), k)) {
        return Some(e.snd());
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
      if (keyEqual(e.fst(), t.fst()) && valueEqual(t.snd(), t.snd())) return true;
    }
    
    return false;
  }
  
  public function containsKey(k: K): Bool {
    return switch(get(k)) {
      case None     : false;
      case Some(_)  : true;
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
            return entryIterator.next().fst();
          }
        }
      }
    }
  }
  
  public function keySet(): Set<K> {
    return Set.create(keyOrder, keyEqual, keyMap, keyShow).append(keys());
  }
  
  public function values(): Iterable<V> {
    var self = this;
    
    return {
      iterator: function() {
        var entryIterator = self.entries().iterator();
        
        return {
          hasNext: entryIterator.hasNext,
          
          next: function() {
            return entryIterator.next().snd();
          }
        }
      }
    }
  }

  public function iterator(): Iterator<Tuple2<K, V>> {
    return Foldables.iterator(this);
  }

  public function compare(other : Map<K, V>) {
    //trace('compare');
    var a1 = this.toArray();
    var a2 = other.toArray(); 
    
    var sorter = function(t1: Tuple2<K, V>, t2: Tuple2<K, V>): Int {
      var c = keyOrder(t1.fst(), t2.fst());
      return if(c != 0)
        c;
      else
        valueOrder(t1.snd(), t2.snd());
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
          return keyShow(t.fst()) + " -> " + valueShow(t.snd()); 
        }
      );  
  }
  public function hashCode() {
    return foldl(786433, function(a, b) return a + (keyMap(b.fst()) * 49157 + 6151) * valueMap(b.snd()));
  }

  public function load(): Int {
    return if (_buckets.length == 0) MaxLoad;
           else Math.round(this.size() / _buckets.length);
  }

  public function withKeyOrderFunction(order : OrderFunction<K>) {
    return create(order, keyEqual, keyMap, keyShow, valueOrder, valueEqual, valueMap, valueShow).append(this);
  }

  public function withKeyEqualFunction(equal : EqualFunction<K>) {
    return create(keyOrder, equal, keyMap, keyShow, valueOrder, valueEqual, valueMap, valueShow).append(this);
  }

  public function withKeyMapFunction(hash : MapFunction<K>) {
    return create(keyOrder, keyEqual, hash, keyShow, valueOrder, valueEqual, valueMap, valueShow).append(this);
  }

  public function withKeyShowFunction(show : ShowFunction<K>) { 
    return create(keyOrder, keyEqual, keyMap, show, valueOrder, valueEqual, valueMap, valueShow).append(this);
  }

  public function withValueOrderFunction(order : OrderFunction<V>) {
    return create(keyOrder, keyEqual, keyMap, keyShow, order, valueEqual, valueMap, valueShow).append(this);
  }

  public function withValueEqualFunction(equal : EqualFunction<V>) {
    return create(keyOrder, keyEqual, keyMap, keyShow, valueOrder, equal, valueMap, valueShow).append(this);
  }

  public function withValueMapFunction(hash : MapFunction<V>) {
    return create(keyOrder, keyEqual, keyMap, keyShow, valueOrder, valueEqual, hash, valueShow).append(this);
  }

  public function withValueShowFunction(show : ShowFunction<V>) { 
    return create(keyOrder, keyEqual, keyMap, keyShow, valueOrder, valueEqual, valueMap, show).append(this);
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
      
      if (ke(entry.fst(), k)) {
        if (ignoreValue || ve(entry.snd(), v)) {
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
    return new Map<K, V>(keyOrder, keyEqual, keyMap, keyShow, valueOrder, valueEqual, valueMap, valueShow, newTable, size());
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
        var bucket = bucketFor(e.fst());
      
        _buckets[bucket].push(e);
      }
    }
  }
  private function bucketFor(k: K): Int {
    return keyMap(k) % _buckets.length;
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
    return stx.ds.Map.create().append(i);
  }	
}
class FoldableToMap {
	public static function toMap<A, K, V>(foldable : Foldable<A, Tuple2<K, V>>) : Map<K, V> {  
    var dest = Map.create();
    return foldable.foldl(dest, function(a, b) {
      return a.add(b);
    });
  }	
}
class ArrayToMap {
  public static function toMap<K, V>(arr : Array<Tuple2<K, V>>) {
    return stx.ds.Map.create().append(arr);
  }	
}
class MapExtensions {
  public static function toObject<V>(map: Map<String, V>): Dynamic<V> {
    return map.foldl({}, function(object, tuple) {
      Reflect.setField(object, tuple.fst(), tuple.snd());
      
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