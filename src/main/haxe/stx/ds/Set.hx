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

using stx.Tuples;
using stx.Prelude;


import stx.functional.Foldable;
import stx.ds.Collection;
import stx.functional.Foldables;

using stx.plus.Order; 
using stx.plus.Hasher;
using stx.plus.Show;
using stx.plus.Equal;

using stx.functional.Foldables;

class FoldableToSet {
	public static function toSet<A, B>(foldable : Foldable<A, B>) : Set<B> {  
    var dest = Set.create();
    return foldable.foldl(dest, function(a, b) {
      return a.add(b);
    });
  }	
}
class ArrayToSet {
	public static function toSet<T>(arr : Array<T>) {
    return stx.ds.Set.create().append(arr);
  }	
}
/** A cross-platform, immutable Set built on Map. */
class Set<T> implements Collection<Set<T>, T> {
  public var equal (get_equal, null): EqualFunction<T>;
  public var order (get_order, null) : OrderFunction<T>;
  public var hash (get_hash, null) : HashFunction<T>;
  public var show (get_show, null) : ShowFunction<T>;
  
  var _map: Map<T,T>;
  
	public static function toSet<T>(i: Iterable<T>) {
    return stx.ds.Set.create().append(i);
  }
  public static function create<T>(?order: OrderFunction<T>, ?equal: EqualFunction<T>, ?hash: HashFunction<T>, ?show: ShowFunction<T>): Set<T> {  
    return new Set<T>(Map.create(order, equal, hash, show));
  }
  
  /** Creates a factory for sets of the specified type. */
  public static function factory<T>(?order: OrderFunction<T>, ?equal: EqualFunction<T>, ?hash: HashFunction<T>, ?show: ShowFunction<T>): Factory<Set<T>> {
    return function() {
      return Set.create(order, equal, hash, show);
    }
  }

  private function new(map: Map<T, T>) {
    _map = cast map;
  }
  
  public function contains(e: T): Bool {
    return _map.containsKey(e);
  }
  
  public function unit<C, D>(): Foldable<C, D> {
    return cast create();
  }
  
  public function foldl<Z>(z: Z, f: Z -> T -> Z): Z {
    var acc = z;
    
    for (e in _map) {
      acc = f(acc, e.fst());
    }
    
    return acc;
  }
  
  public function add(t: T): Set<T> {
    return if (contains(t)) this; else copyWithMod(_map.set(t, t));
  }
  
  public function append(it: Iterable<T>): Set<T> {
    var set = this;
    
    for (e in it) set = set.add(e);
    
    return set;
  }
  
  public function remove(t: T): Set<T> {
    return copyWithMod(_map.removeByKey(t));
  }
  
  public function removeAll(it: Iterable<T>): Set<T> {
    var set = this;
    
    for (e in it) set = set.remove(e);
    
    return set;
  }
  
  public function iterator(): Iterator<T> {
    return Foldables.iterator(this);
  } 
          
  public function equals(other : Set<T>) {
    var all = concat(other);
    return all.size() == size() && all.size() == other.size();
  }

  public function compare(other : Set<T>) {
    return toArray().compareWith(other.toArray(), order);
  } 

  public function hashCode() : Int {
    var ha = hash;
    return foldl(393241, function(a, b) return a * (ha(b) + 6151));
  }
  public function toString(): String {    
    return "Set " + toArray().toStringWith(show);
  } 
  
  public function withOrderFunction(order : OrderFunction<T>) {
    var m : FriendMap<T> = cast _map;
    return create(order, m.keyEqual, m.keyMap, m.keyShow).append(this);
  }
  
  public function withEqualFunction(equal : EqualFunction<T>) {
    var m : FriendMap<T> = cast _map;
    return create(m.keyOrder, equal, m.keyMap, m.keyShow).append(this);
  }
  
  public function withHashFunction(hash : HashFunction<T>) {
    var m : FriendMap<T> = cast _map;
    return create(m.keyOrder, m.keyEqual, hash, m.keyShow).append(this);
  }
  
  public function withShowFunction(show : ShowFunction<T>) { 
    var m : FriendMap<T> = cast _map;
    return create(m.keyOrder, m.keyEqual, m.keyMap, show).append(this);
  }
  
  /**
   *  @:todo inject *Functions here?
   */ 
  private function copyWithMod(newMap: Map<T, T>): Set<T> {
    return new Set<T>(newMap);
  }
  
  public function size(): Int {
    return _map.size();
  } 

  function get_order() {
    return _map.keyOrder;     
  }
  
  function get_equal() { 
    return _map.keyEqual;
  } 
  
  function get_hash() {
    return _map.keyMap;
  }
  
  function get_show() {    
    return _map.keyShow;
  }
}     

private typedef FriendMap<K> = {
  private var keyEqual  : EqualFunction<K>;
  private var keyOrder  : OrderFunction<K>;
  private var keyMap : HashFunction<K>;
  private var keyShow   : ShowFunction<K>;
}