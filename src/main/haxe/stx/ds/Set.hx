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
using Prelude;

import stx.ds.ifs.Foldable;
import stx.ds.ifs.Collection;
import stx.ds.Foldables;
import stx.plus.Plus;

using stx.plus.Order; 
using stx.plus.Hasher;
using stx.plus.Show;
using stx.plus.Equal;

using stx.ds.Foldables;

class FoldableToSet {
	public static function toSet<A, B>(foldable : Foldable<A, B>) : Set<B> {  
    var dest = Set.create();
    return foldable.foldLeft(dest, function(a, b) {
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
  
  var _map: Map<T,T>;
  
	public static function toSet<T>(i: Iterable<T>) {
    return stx.ds.Set.create().append(i);
  }
  public static function create<T>(?val_tool:Plus<T>): Set<T> {  
    return new Set<T>(Map.create(val_tool,val_tool));
  }
  /** Creates a factory for sets of the specified type. */
  public static function factory<T>(val_tool): Thunk<Set<T>> {
    return function() {
      return Set.create(val_tool);
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
  public function foldLeft<Z>(z: Z, f: Z -> T -> Z): Z {
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
  public function equals(other:Set<T>) {
    var all = concat(other);
    return all.size() == size() && all.size() == other.size();
  }
  public function compare(other:Set<T>) {
    return _map.compare(other._map);
  }
  public function hashCode():Int{
    var ha = _map.val_tool.getHash;
    return foldLeft(393241, function(a, b) return a * (ha(b)(b) + 6151));
  }
  public function toString():String{    
    return "Set " + 
      IterableShow.toString(_map.entries(),
        function(t:Tuple2<T,T>):String{ 
          return _map.val_tool.getShow(t.snd())(t.snd()); 
        }
      );
  } 
  public function withOrder(order:Reduce<T,Int>) {
    return create(_map.val_tool.withOrder(order)).append(this);
  }
  public function withEqual(equal:Reduce<T,Bool>) {
    return create(_map.val_tool.withEqual(equal)).append(this);
  }
  public function withHash(hash:T->Int) {
    return create(_map.val_tool.withHash(hash)).append(this);
  }
  public function withShow(show:T->String) {  
    return create(_map.val_tool.withShow(show)).append(this);
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
}     