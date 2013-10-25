package stx.ds;

import stx.plus.Plus;
import stx.Prelude;

import stx.Tuples;

import stx.ds.ifs.Foldable;
import stx.ds.ifs.Collection;
import stx.ds.Foldables;
import stx.plus.Plus.*;

using stx.Maths;
using stx.Options;
using stx.Tuples;
using stx.Prelude;

using stx.plus.Order; 
using stx.plus.Hasher;
using stx.plus.Show; 
using stx.plus.Equal;

using stx.ds.Foldables;

class ArrayToList {
  public static function toList<T>(arr : Array<T>) {
    return stx.ds.List.create().append(arr);
  }	
}
class FoldableToList {
  public static function toList<A, B>(foldable : Foldable<A,B>) : List<B> {  
    var dest = List.create();
    return foldable.foldl(dest, function(a, b) {
      return a.add(b);
    });
  }	
}
/** A classic immutable list built from cons and nil elements. */
class List<T> implements Collection<List<T>,T> {
  public var head (get_head, null): T;
  public var tail (get_tail, null): List<T>;

  public var first (get_first, null): T;
  public var last  (get_last, null): T;

  public var headOption  (get_headOption, null): Option<T>;
  public var firstOption (get_firstOption, null): Option<T>;
  public var lastOption  (get_lastOption, null): Option<T>;
  
  public var equal (get_equal, null) : EqualFunction<T>;
  function get_equal() {
    return 
      if (equal == null || equal == NullEqual.equals ){
        headOption.map( Equal.getEqualFor )
        .foreach(function(x) equal = x)
        .getOrElseC( NullEqual.equals );
      }else{
        equal;
      }
  }  
  public var order (get_order, null) : OrderFunction<T>;
  function get_order() {
    return 
      if (order == null || order == Order.nil ){
        headOption.map( Order.getOrderFor )
        .foreach( function(x) order = x)
        .getOrElseC( Order.getOrderFor(null) );
      }else{
        order;
      }
  }  

  public var hash(get_hash, null) : HashFunction<T>;
  function get_hash(){
    return 
      if (hash == null || hash == Hasher.nil ){
        headOption.map( Hasher.getHashFor )
        .foreach(function(x) hash = x)
        .getOrElseC( Hasher.nil );
      }else{
        hash;
      }
  }
  public var show  (get_show, null) : ShowFunction<T>;
  function get_show(){
    return 
      if (show == null || show == NullShow.toString ){
        headOption.map( Show.getShowFor )
        .foreach(function(x) show = x)
        .getOrElseC( NullShow.toString );
      }else{
        show;
      }
  }

	public static function toList<T>(i: Iterable<T>) {
    return stx.ds.List.create().append(i);
  }
  public static function nil<T>(?tools : Tool<T>): List<T> {
    return new Nil(tools);
  }
  
  @:noUsing public static function create<T>(?tools:Tool<T>): List<T> {
    return nil(tools);
  }

  /** Creates a factory for lists of the specified type. */
  public static function factory<T>(?tools:Tool<T> ): Factory<List<T>> {
    return function() {
      return List.create(tools);
    }
  }

  private function new(?tools:Tool<T>) {
		if(tools!=null){
				order   = tools.order;
				equal   = tools.equal;  
				hash    = tools.hash; 
				show    = tools.show; 
		}
  }

  public function unit<C,T>(): Foldable<C,T> {
    return cast nil();
  }

  /** Prepends an element to the list. This method is dramatically faster than
   * appending an element to the end of the list. In general, you should
   * construct lists by prepending, and then reverse at the end if necessary.
   */
  public function cons(head: T): List<T> {
    return new Cons(tool(order,equal,hash,show), head, this);
  }
  
  public function prepend(iterable: Iterable<T>): List<T> {
    var result = this;

    var array = iterable.toArray();

    array.reverse();

    for (e in array) result = result.cons(e);

    return result;
  }

  public function prependR(iterable: Iterable<T>): List<T> {
    var result = this;

    for (e in iterable) result = result.cons(e);

    return result;
  }

  public function foldl<Z>(z: Z, f: Z -> T -> Z): Z {
    var acc = z;
    var cur = this;

    for (i in 0...size()) {
      acc = f(acc, cur.head);

      cur = cur.tail;
    }

    return acc;
  }

  /** A right fold. Right folds are much more efficient when folding to
   * another list.
   */
  public function foldr<Z>(z: Z, f: T -> Z -> Z): Z {
    var a = this.toArray();

    var acc = z;

    for (i in 0...size()) {
      var e = a[size() - 1 - i];

      acc = f(e, acc);
    }

    return acc;
  }

  public function contains(t: T): Bool {
    var cur = this;
    var eq = equal;
    for (i in 0...size()) {
      if (eq(t, cur.head)) return true;
      cur = cur.tail;
    }

    return false;
  }

  /** Adds an item to the end of the list. This is a slow method; for high performance,
   * the cons() method should be used to grow the list.
   */
  public function add(t: T): List<T> {
    return foldr(create(tool(order, equal, hash, show)).cons(t), function(b, a) {
      return a.cons(b);
    });
  }

   public function append(i: Iterable<T>): List<T> {
    var a = [];

    for (e in i) a.push(e);

    a.reverse();

    var r = create( tool(order, equal, hash, show) );

    for (e in a) r = r.cons(e);

    return foldr(r, function(b, a) {
      return a.cons(b);
    });
  }

  public function remove(t: T): List<T> {
    var pre: Array<T> = [];
    var post: List<T> = nil(tool(order, equal, hash, show));
    var cur = this;      
    var eq = equal;
    for (i in 0...size()) {
      if (eq(t, cur.head)) {
        post = cur.tail;

        break;
      }
      else {
        pre.push(cur.head);

        cur = cur.tail;
      }
    }

    pre.reverse();

    var result = post;

    for (e in pre) {
      result = result.cons(e);
    }

    return result;
  }

  public function removeAll(i: Iterable<T>): List<T> {
    var r = this;

    for (e in i) r = r.remove(e);

    return r;
  }

  /** Override Foldable to provide higher performance: */
  public function concat(l: List<T>): List<T> {
    return this.append(l);
  }

  /** Override Foldable to provide higher performance: */
  public function drop(n: Int): List<T> {
    var cur = this;

    for (i in 0...size().min(n)) {
      cur = cur.tail;
    }

    return cur;
  }

  /** Override Foldable to provide higher performance: */
  public function dropWhile(pred: T -> Bool): List<T> {
    var cur = this;

    for (i in 0...size()) {
      if (pred(cur.head)) return cur;

      cur = cur.tail;
    }

    return cur;
  }

  /** Override Foldable to provide higher performance: */
  public function take(n: Int): List<T> {
    return reverse().drop(size() - n);
  }

  /** Override Foldable to provide higher performance: */
  public function map<B>(f: T -> B): List<B> {
    return foldr(create(), function(e, list) return list.cons(f(e)));
  }

  /** Override Foldable to provide higher performance: */
  public function flatMap<B>(f: T -> Iterable<B>): List<B> {
    return foldr(create(), function(e, list) return list.prepend(f(e)));
  }

  /** Override Foldable to provide higher performance: */
  public function filter(f: T -> Bool): List<T> {
    return foldr(create(tool(order, equal, hash, show)), function(e, list) return if (f(e)) list.cons(e) else list);
  }

  /** Returns a list that contains all the elements of this list in reverse
   * order */
  public function reverse(): List<T> {
    return foldl(create(tool(order, equal, hash, show)), function(a, b) return a.cons(b));
  }

  /** Zips this list and the specified list into a list of tuples. */
  public function zip<U>(that: List<U>): List<Tuple2<T, U>> {
    var len = this.size().min(that.size());

    var iterator1 = this.reverse().drop(0.max(this.size() - len)).iterator();
    var iterator2 = that.reverse().drop(0.max(that.size() - len)).iterator();

    var r = List.create();

    for (i in 0...len) {
      r = r.cons(tuple2(iterator1.next(), iterator2.next()));
    }

    return r;
  }

  /** Retrieves a list of gaps in this sequence.
   *
   * @param f Called with every two consecutive elements to retrieve a list of gaps.
   */
  public function gaps<G>(f: T -> T -> List<G>, ?equal: EqualFunction<G>): List<G> {
    var l : List<G> 
      = zip(drop(1)).flatMapTo(List.nil(tool(null,equal)), function(tuple) return f(tuple.fst(), tuple.snd()));
    return l;
  }

  /** Returns a list that contains all the elements of this list, sorted by
   * the ordering function.
   */        
  public function sort(): List<T> {
    var a = this.toArray();
    a.sort(order);
    var result = create(tool(order, equal, hash, show));

    for (i in 0...a.length) {
      result = result.cons(a[a.length - 1 - i]);
    }

    return result;
  } 

  public function iterator(): Iterator<T> {
    return Foldables.iterator(this);
  }
  
  public function withOrderFunction(order : OrderFunction<T>) {
    return create(tool(order,equal,hash,show)).append(this);
  }
  
  public function withEqualFunction(equal : EqualFunction<T>) {
    return create(tool(order, equal, hash, show)).append(this);
  }
  
  public function withHashFunction(hash : HashFunction<T>) {
    return create(tool(order, equal, hash, show)).append(this);
  }
  
  public function withShowFunction(show : ShowFunction<T>) {
    return create(tool(order, equal, hash, show)).append(this);
  }

  public function equals(other : List<T>) {     
    return toArray().equalsWith(other.toArray(), equal);
  }

  public function compare(other : List<T>) {
    return toArray().compareWith(other.toArray(), order);   
  } 
   
  public function hashCode() : Int { 
    var ha = hash;
    return foldl(12289, function(a, b) return a * (ha(b) + 12289));
  }

  public function toString(): String { 
    return "List " + toArray().toStringWith(show);
  }

  public function size(): Int {
    return 0;
  }

  private function get_head(): T {
    return Prelude.error()("List has no head element");
  }
  private function get_first(): T {
    return Prelude.error()("List has no head element");
  }
  private function get_last(): T {
    return Prelude.error()("List has no last element");
  }

  private function get_headOption(): Option<T> {
    return None;
  }
  private function get_firstOption(): Option<T> {
    return None;
  }

  private function get_lastOption(): Option<T> {
    return None;
  }

  private function get_tail(): List<T> {
    return Prelude.error()("List has no head");
  }
}

private class Cons<T> extends List<T> {
  var _head: T;
  var _tail: List<T>;
  var _size: Int;

  public function new(tools:Tool<T>, head: T, tail: List<T>) {
    super(tools);
    _head = head;
    _tail = tail;
    _size = tail.size() + 1;
  }

  override private function get_head(): T {
    return _head;
  }
  override private function get_first(): T{
    return _head;
  }
  override private function get_last(): T {
    var cur: List<T> = this;

    for (i in 0...(size() - 1)) {
      cur = cur.tail;
    }

    return cur.head;
  }

  override private function get_tail(): List<T> {
    return _tail;
  }

  override private function get_headOption(): Option<T> {
    return Some(head);
  }
  override private function get_firstOption(): Option<T> {
    return Some(head);
  }
  override private function get_lastOption(): Option<T> {
    return Some(last);
  }

  override public function size(): Int {
    return _size;
  }
}

private class Nil<T> extends List<T> {
  public function new(tools:Tool<T>) {
    super(tools);
  }
}
class Lists{
  static public function add<A>(l:List<A>,v:A){
    return l.add(v);
  }
  static public function remove<A>(l:List<A>,v:A){
    return l.remove(v);
  }
}