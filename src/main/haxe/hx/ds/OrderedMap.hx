package hx.ds;


import Stax.*;
import stx.Compare.*;

import stx.Prelude;
import stx.plus.Order;
import stx.plus.Show;
import stx.plus.Hasher;

using stx.Iterators;
using stx.plus.Order;
using stx.Option;
using stx.Tuples;
using stx.Compose;

import stx.plus.Hasher;

class OrderedMap<K,V>{
  private var __key_sort__  : OrderFunction<K>;
  private var __val_sort__  : OrderFunction<V>;
  private var __val_equal__ : OrderFunction<V>;
  private var __key_hash__  : HashFunction<K>;

  private var impl    : OrderedHashMap<Tuple2<K,V>>;

  public function new(){
    impl = new OrderedHashMap();
  }
  public function set(key:K,val:V){
    impl.set(encode(key),tuple2(key,val));
  }
  public function has(key:K){
    return impl.has(encode(key));
  }
  public function at(i:Int):V{
    return option(impl.at(i)).map(Tuples2.snd).getOrElse(thunk(null));
  }
  public function get(key:K):V{
    return option(impl.get(encode(key))).map(Tuples2.snd).getOrElse(thunk(null));
  }
  public function del(key:K){
    return impl.del(encode(key)); 
  }
  public function rem(val:V){
    var found = false;
  }
  public function sort(){
    impl.impl = ArrayOrder.sort(impl.impl);
  }
  public function sortWith(fn:OrderFunction<Tuple2<K,V>>){
    impl.sortOnValWith(fn);
  }
  public function sortOnKey(){
    var _k = function(x,y) return nl().apply(__key_sort__) ? (__key_sort__ = Order.getOrderFor(x))(x,y) : __key_sort__(x,y);
    impl.sortOnValWith(
      function(x,y){
        return _k(x.fst(),y.fst());
      }
    );
  }
  public function sortOnKeyWith(fn:K->K->Int){
    impl.sortOnValWith(
      function(x,y){
        return fn(x.fst(),y.fst());
      }
    );
  }
  public function sortOnVal(){
    var _v = function(x,y) return nl().apply(__val_sort__) ? (__val_sort__= Order.getOrderFor(x))(x,y) : __val_sort__(x,y);
    impl.sortOnValWith(
      function(x,y){
        return _v(x.snd(),y.snd());
      }
    );
  }
  public function sortOnValWith(fn:V->V->Int){
    impl.sortOnValWith(
      function(x,y){
        return fn(x.snd(),y.snd());
      }
    );
  }
  public function iterator(){
    return impl.iterator();
  }
  public function vals():Iterator<V>{
    return impl.vals().map(Tuples2.snd);
  }
  public function lookup(key:K):Option<Tuple2<K,V>>{
    return untyped impl.lookup(encode(key));
  }
  public function find(val:V){
    var eq = eq(val);
    return this.search(eq.apply);
  }
  public function search(fn:V->Bool){
    return impl.search(
      function(x){
        return fn(x.snd());
      }
    );
  }
  private function encode(key:K):Int{
    return (nl().apply(__key_hash__) ? (__key_hash__ = Hasher.getHashFor(key)) : __key_hash__)(key);
  }
  public function size(){
    return impl.size();
  }
  public function toString():String{
    return impl.toString();
  }
}