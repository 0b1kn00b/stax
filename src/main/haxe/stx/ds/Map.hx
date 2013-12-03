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

import Stax.*;
import stx.Compare.*;

import stx.Tuples;
import stx.ds.ifs.Foldable;
import stx.ds.ifs.Collection;

import stx.plus.Order; 
import stx.plus.Hasher;
import stx.plus.Show;
import stx.plus.Equal;
import stx.plus.Plus;

using stx.Tuples;
using Prelude;
using stx.Bools;
using stx.PartialFunction;
using stx.Option;
using stx.Functions;
using stx.Iterables;
using stx.ds.Foldables;

private typedef NativeMap<K,V> = std.Map<K,V>;
typedef StringMap<T>           = Map<String,T>;

class Map<K, V> implements Collection<Map<K, V>, Tuple2<K, V>> {
  public static var MaxLoad = 10;
  public static var MinLoad = 1;

  public  var val_tool  : Plus<V>;
  public  var key_tool  : Plus<K>;
  private var _buckets  : Array<Array<Tuple2<K, V>>>;
  private var _size     : Int;
    
  public static function create<K, V>(?key_tool:Plus<K>,?val_tool:Plus<V>) {
    return new Map<K, V>(key_tool,val_tool, [[]], 0);
  }
  /** Creates a factory for maps of the specified types. */
  public static function factory<K, V>(?key_tool,?val_tool): Thunk<Map<K, V>> {
    return function() {
      return Map.create(key_tool,val_tool);
    }
  }
  private function new(key_tool: Plus<K>, val_tool : Plus<V>, buckets: Array<Array<Tuple2<K, V>>>, size: Int) {
    var self = this;

    this.key_tool   = nl().apply(key_tool) ? new Plus() : key_tool;
    this.val_tool   = nl().apply(val_tool) ? new Plus() : val_tool;
    this._size      = size;
    this._buckets   = buckets == null ? [[]] : buckets;
  }
  public function unit<C, D>(): Foldable<C, D> {
    return cast create();
  }
  public function foldLeft<Z>(z: Z, f: Z -> Tuple2<K, V> -> Z): Z {
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

      if (key_tool.getEqual(entry.fst())(entry.fst(), key)) {
        if (!val_tool.getEqual(entry.snd())(entry.snd(), value)) {
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
      if (key_tool.getEqual(e.fst())(e.fst(), k)) {
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
      if (key_tool.getEqual(e.fst())(e.fst(), t.fst()) && val_tool.getEqual(t.snd())(t.snd(), t.snd())) return true;
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
    return Set.create(key_tool).append(keys());
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
      var c = key_tool.getOrder(t1.fst())(t1.fst(), t2.fst());
      return if(c != 0)
        c;
      else
        val_tool.getOrder(t1.snd())(t1.snd(), t2.snd());
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
      if (!val_tool.getEqual(v1)(v1, v2)) return false;
    }
    return true;
  }
  public function toString() { 
    return "Map " + 
      IterableShow.toString(entries(),
        function(t:Tuple2<K,V>):String{ 
          return key_tool.getShow(t.fst())(t.fst()) + " -> " + val_tool.getShow(t.snd())(t.snd()); 
        }
      );  
  }
  public function hashCode() {
    return foldLeft(786433, function(a, b) return a + (key_tool.getHash(b.fst())(b.fst()) * 49157 + 6151) * val_tool.getHash(b.snd())(b.snd()));
  }

  public function load(): Int {
    return if (_buckets.length == 0) MaxLoad;
           else Math.round(this.size() / _buckets.length);
  }

  public function withKeyOrder(order : Reduce<K,Int>) {
    return create(key_tool.withOrder(order),val_tool).append(this);
  }
  public function withKeyEqual(equal : Reduce<K,Bool>) {
    return create(key_tool.withEqual(equal), val_tool).append(this);
  }
  public function withKeyHash(hash : K->Int) {
    return create(key_tool.withHash(hash), val_tool).append(this);
  }
  public function withKeyShow(show : K->String) { 
    return create(key_tool.withShow(show),val_tool).append(this);
  }
  public function withValueOrder(order : Reduce<V,Int>) {
    return create(key_tool,val_tool.withOrder(order)).append(this);
  }
  public function withValueEqual(equal : Reduce<V,Bool>) {
    return create(key_tool,val_tool.withEqual(equal)).append(this);
  }
  public function withValueHash(hash : V->Int) {
    return create(key_tool,val_tool.withHash(hash)).append(this);
  }
  public function withValueShow(show : V->String) { 
    return create(key_tool, val_tool.withShow(show)).append(this);
  }

  @:allow(stx.ds)
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
    
    var ke = key_tool.getEqual;
    var ve = val_tool.getEqual;
    
    for (i in 0...list.length) {
      var entry = list[i];
      
      if (ke(entry.fst())(entry.fst(), k)) {
        if (ignoreValue || ve(entry.snd())(entry.snd(), v)) {
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
    return new Map<K, V>(key_tool, val_tool, newTable, size());
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
    return key_tool.getHash(k)(k) % _buckets.length;
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
    return foldable.foldLeft(dest, function(a, b) {
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
    return map.foldLeft({}, function(object, tuple) {
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
/*class NativeMapToMap{
  static public function toMap<I,O>(m:NativeMap<I,O>):Map<I,O>{
    var nm : Map<I,O> = Map.create();
    for( key in m.keys() ){
      var val = m.get(key);
      nm.set(key,val);
    }
    return nm;
  }
}*/