package stx;

using stx.Prelude;

import stx.Tuples;

using stx.Tuples;
using stx.Functions;
using stx.Iterables;
using stx.ds.Generator;

class Iterables {
  /**
    Creates an Array from an Iterable
  */
  static public function toArray<T>(i: Iterable<T>) {
    var a = [];
    for (e in i) a.push(e);
    return a;
  }
  /**
    Creates an Iterable from an Iterator
  */
  static public function toIterable<T>(it:Iterator<T>):Iterable<T> {
    return {
      iterator : function () {
        return {
            next      : it.next,
            hasNext   : it.hasNext
        }
      }
    }
  }
  /**
    Applies function f to each element in iter, returning the results
  */
  static public function map<T, Z>(iter: Iterable<T>, f: T -> Z): Iterable<Z> {
    return foldl(iter, [], function(a, b) {
      a.push(f(b));
      return a;
    });
  }
  /**
    Applies function f to each element in iter, appending and returning the results.
  */
  static public function flatMap<T, Z>(iter: Iterable<T>, f: T -> Iterable<Z>): Iterable<Z> {
    return foldl(iter, [], function(a, b) {
      for (e in f(b)) a.push(e);
      return a;
    });
  }
  /**
    Using starting var z, run f on each element, storing the result, and passing that result 
    into the next call.
      [1,2,3,4,5].foldl( 100, function(init,v) return init + v ));//(((((100 + 1) + 2) + 3) + 4) + 5)
  */
  static public function foldl<T, Z>(iter: Iterable<T>, seed: Z, mapper: Z -> T -> Z): Z {
    var folded = seed;
    for (e in iter) { folded = mapper(folded, e); }
    return folded;
  }   
  /**
    Call f on each element in iter, returning a collection where f(e) = true
  */
  static public function filter<T>(iter: Iterable<T>, f: T -> Bool): Iterable<T> {
    return SArrays.filter(iter.toArray(), f);
  }
  /**
    Returns the size of iter
  */
  static public function size<T>(iterable: Iterable<T>): Int {
    var size = 0;
    
    for (e in iterable) ++size;
    
    return size;
  }
  /**
    Apply f to each element in iter.
  */
  static public function foreach<T>(iter : Iterable<T>, f : T-> Void ):Iterable<T> {
    for (e in iter) f(e);
    return iter;
  }
  /**
    Preforms a foldl, using the first value as the init value
  */
	 public static function foldl1<T, T>(iter: Iterable<T>, mapper: T -> T -> T): T {
    var folded = iter.head();
		switch (iter.tailOption()) {
			case Some(v) 	:
				for (e in v) { folded = mapper(folded, e); }
			default 			:
		}
    return folded;
  }
  /**
    Concetenates two Iterables
  */
  public static function concat<T>(iter1: Iterable<T>, iter2: Iterable<T>): Iterable<T>
    return iter1.toArray().concat(iter2.toArray());
  /**
    Fold the collection from the right hand side
  */
  public static function foldr<T, Z>(iterable: Iterable<T>, z: Z, f: T -> Z -> Z): Z {
    return Arrays.foldr(iterable.toArray(), z, f);
  }
  /**
    Produces the first element of `iter` as an Option, Option.None if the Iterable is empty.
  */
  public static function headOption<T>(iter: Iterable<T>): Option<T> {
    var iterator = iter.iterator();
    return if (iterator.hasNext()) {
			var o = iterator.next();
			Some(o);
		}else {None;
		}
  }
  /**
    Produces the first elelment of `iter`, throwing an error if the Iterable is empty.
  */
  public static function head<T>(iter: Iterable<T>): T {
    return switch(headOption(iter)) {
      case None: Prelude.error()('Iterable has no head');
      case Some(h): h;
    }
  }
  /**
    Drops the first value, returning Some if there are further values, None if there aren't
  */
  public static function tailOption<T>(iter: Iterable<T>): Option<Iterable<T>> {
    var iterator = iter.iterator();
    return if (!iterator.hasNext()) None;
           else Some(drop(iter, 1));
  }
  /**
    Take element[1...n] from the Iterable, or if Iterable.size() == 1, element[0]
    Throws an error if no further values exist.
    @param iter
    @return Iterable
   */
  public static function tail<T>(iter: Iterable<T>): Iterable<T> {
    return switch (tailOption(iter)) {
      case None: Prelude.error()('Iterable has no tail');
      
      case Some(t): t;
    }
  }
  /**
    Drop `n` values from iter
  */
  public static function drop<T>(iter: Iterable<T>, n: Int): Iterable<T> {
    var iterator = iter.iterator();
    
    while (iterator.hasNext() && n > 0) {
      iterator.next();
      --n;
    }
    
    var result = [];
		
    while (iterator.hasNext()) {
			
			result.push(iterator.next());
		}
    
    return result;
  }
  /**
    Drop values from iter while p(e) = true.
  */
  public static function dropWhile<T>(iter: Iterable<T>, p: T -> Bool): Iterable<T> {
    var r = [].append(iter);
    
    for (e in iter) {
      if (p(e)) {
				switch (r.tailOption()) {
					case Some(v) 	: r = v;
					default:			 r = [];
				}
			}else {
				break;
			}
    }
    return r;
  }
  /**
    Return the first n values from iter.
  */
  public static function take<T>(iter: Iterable<T>, n: Int): Iterable<T> {
    var iterator = iter.iterator();
    var result = [];
    
    for (i in 0...(n)) {
      if (iterator.hasNext()) { result.push(iterator.next()); };
    }
    
    return result;
  }
  /**
    Return the first values where p(e) == true until p(e) == false
  */
	public static function takeWhile<T>(a: Iterable<T>, p: T -> Bool): Iterable<T> {
    var r = [];
    
    for (e in a) {
      if (p(e)) r.push(e); else break;
    }
    
    return r;
  }
  /**
    Return true if any fn(e) returns true
  */
  public static function exists<T>(iter: Iterable<T>, fn: T -> Bool): Bool {
    for (element in iter)
      if (fn(element)) { return true; };
    return false;
  }
  /**
    Returns true if any `eq` returns true, using `value`
  */
  public static function has<T>(iter:Iterable<T>,value:T,?eq : T -> T -> Bool){
    if(eq==null)eq = stx.plus.Equal.getEqualFor(value);
    for (el in iter){
      if( eq(value,el) ){ return true;}
    }
    return false;
  }
  /**
    Preform nub using `f` as a comparator
  */
  public static function nubBy<T>(iter:Iterable<T>, f: T -> T -> Bool): Iterable<T> {
    return SIterables.foldl(iter, [], function(a, b) {
      return if(existsP(a, b, f)) {
        a;
      }
      else {
        a.add(b);
        a;
      }
    });
  }
  /**
    Compare each element to the next, returning the values which have no adjacent equal values.
  */
  public static function nub<T>(iter: Iterable<T>): Iterable<T> {
    var result = [];

    for (element in iter)
      if (!has(result, element, stx.plus.Equal.getEqualFor(iter.head()))) { result.push(element); };
    
    return result;
  }
  /**
    Produces the value at `index`, throwing an error if the index doesn't exist.
  */
  public static function at<T>(iter: Iterable<T>, index: Int): T {
    var result: T = null;
    
    if (index < 0) index = SIterables.size(iter) - (-1 * index);
    
    var curIndex  = 0;
    for (e in iter) {
      if (index == curIndex) {
        return e;
      }
      else ++curIndex;
    }
    return Prelude.error()('Index not found');
  }
  /**
    flatten an iterable of iterables to an iterable
  */
  public static function flatten<T>(iter: Iterable<Iterable<T>>): Iterable<T> {
		var empty : Iterable<T> = [];
		return SIterables.foldl(iter, empty, concat);
  }
  /**
    For each Iterable, take each element and flatten to an output
  */
  public static function interleave<T>(iter: Iterable<Iterable<T>>): Iterable<T> {
		var alls = iter.map(function (it) return it.iterator()).toArray();
		var res = [];		
		while (stx.Arrays.forAll(alls, function (iter) return iter.hasNext())) { //alls.forAll(function (iter) return iter.hasNext()))  <- stack overflow!!
			alls.foreach(function (iter) res.push(iter.next()));
		}
		return res;
  }
  /**
    Produces an Iterable of Tuples where the left side of each element is taken from iter1 and the right is taken from iter2.
  */
  public static function zip<T1, T2>(iter1: Iterable<T1>, iter2: Iterable<T2>): Iterable<Tuple2<T1, T2>> {
    var i1 = iter1.iterator();
    var i2 = iter2.iterator();
    
    var result = [];
    
    while (i1.hasNext() && i2.hasNext()) {
      var t1 = i1.next();
      var t2 = i2.next();
      
      result.push(tuple2(t1,t2));
    }
    
    return result;
  }
  /**
    Zip an Iterable of tuples from a tuple of iterables
  */
  public static function zipup<T1, T2>(tuple:Tuple2<Iterable<T1>, Iterable<T2>>): Iterable<Tuple2<T1, T2>> {
    var i1 = tuple.fst().iterator();
    var i2 = tuple.snd().iterator();
    
    var result = [];
    
    while (i1.hasNext() && i2.hasNext()) {
      var t1 = i1.next();
      var t2 = i2.next();
      
      result.push(tuple2(t1,t2));
    }
    return result;
  }
  /**
    Produces an `Array` of the result of `f` where the left parameter is `a[n]`, and the right: `b[n]`
   */
  static public function zipWith<A, B, C>(a: Iterable<A>, b: Iterable<B>, f : A -> B -> C): Iterable<C> {
    var len = Math.floor(Math.min(a.size(), b.size()));    
    return a.zip(b).map(f.spread());
  }
  /**
    Performs a `zip` where the resulting `Tuple2` has the element on the left, and it's index on the right
   */
  static public function zipWithIndex<A>(a: Iterable<A>): Iterable<Tuple2<A, Int>> {
    return Iterables.zipWithIndexWith(a, tuple2);
  }
   /**
    Performs a `zip` with the right hand parameter is the index of the element.
   */
  static public function zipWithIndexWith<A, B>(a: Iterable<A>, f : A -> Int -> B): Iterable<B> {
    var idx = 0.until(a.size());
    return a.zip(idx).map(f.spread());
  }
  /**
    Append `e` to the end of `iter`.
  */
  public static function add<T>(iter: Iterable<T>, e: T): Iterable<T> {
    return foldr(iter, [e], function(a, b) {
      b.unshift(a);
      
      return b;
    });
  }
  /**
    Returns an iterable with an element prepended.
	  @param iter 	Iterable
	  @param e 		The element to prepend.
   */
  public static function cons<T>(iter: Iterable<T>, e: T): Iterable<T> {
    return SIterables.foldl(iter, [e], function(b, a) {
      b.push(a);
      
      return b;
    });
  }
	/**
	  Returns the Iterable with elements in reverse order.
	 */
  public static function reversed<T>(iter: Iterable<T>): Iterable<T> {
    return SIterables.foldl(iter, [], function(a, b) {
      a.unshift(b);
      
      return a;
    });
  }
  /**
    Returns that all elements in 'iter' are true.
   */
  public static function and<T>(iter: Iterable<Bool>): Bool {
    var iterator = iter.iterator();
    
    while (iterator.hasNext()) {
      var element = iterator.next();
      if (element == false) { return false; }; 
    }
    return true;
  }
  /**
    Returns that any element in 'iter' is true.
   */
  public static function or<T>(iter: Iterable<Bool>): Bool {
    var iterator = iter.iterator();
    
    while (iterator.hasNext()) {
      if (iterator.next() == true) { return true; }; 
    }
    return false;
  }
  /**
    Takes an initial value which is passed to function 'f' along with each element
    one by one, accumulating the results.
    f(element,init)
   */
  public static function scanl<T>(iter:Iterable<T>, init: T, f: T -> T -> T): Iterable<T> {
    var result = [init];
    
    for (e in iter) {
      result.push(f(e, init));
    }
    
    return result;
  }
  /**
    As scanl but from the end of the Iterable.
   */
  public static function scanr<T>(iter:Iterable<T>, init: T, f: T -> T -> T): Iterable<T> {
    return scanl(reversed(iter), init, f);
  }
  /**
    As scanl, but using the first element as the second parameter of 'f'
   */
  public static function scanl1<T>(iter:Iterable<T>, f: T -> T -> T): Iterable<T> {
    var iterator = iter.iterator();
    var result = [];
    if(!iterator.hasNext())
      return result;
    var accum = iterator.next();
    result.push(accum);
    while (iterator.hasNext())
      result.push(f(iterator.next(), accum));
    
    return cast result;
  }
  /**
    As scanr, but using the first element as the second parameter of 'f'
   */
  public static function scanr1<T>(iter:Iterable<T>, f: T -> T -> T): Iterable<T> {
    return scanl1(reversed(iter), f);
  }
  /**
    As with 'exists' but taking a second parameter in the predicate specified by 'ref'
   */
  public static function existsP<T>(iter:Iterable<T>, ref: T, f: T -> T -> Bool): Bool {
    var result:Bool = false;
    
    for (e in iter) {
      if (f(ref, e)) result = true;
    }
    
    return result;
  }
  /**
    Return an Iterable of values contained in both inputs, as decided by ´f´
  */ 
  public static function intersectBy<T>(iter1: Iterable<T>, iter2: Iterable<T>, f: T -> T -> Bool): Iterable<T> {
    return SIterables.foldl(iter1, cast [], function(a: Iterable<T>, b: T): Iterable<T> {
      return if (existsP(iter2, b, f)) add(a, b); else a;
    });
  }
  /**
   Return an Iterable of values contained in both inputs.
  */
  public static function intersect<T>(iter1: Iterable<T>, iter2: Iterable<T>): Iterable<T> {
    return SIterables.foldl(iter1, cast [], function(a: Iterable<T>, b: T): Iterable<T> {
      return if (existsP(iter2, b, stx.plus.Equal.getEqualFor(iter1.head()))) add(a, b); else a;
    });
  }
  /**
    Returns an Iterable of all distinct values in `iter1` and `iter2`, as decided by f
  */  
  public static function unionBy<T>(iter1: Iterable<T>, iter2: Iterable<T>, f: T -> T -> Bool): Iterable<T> {
    var result = iter1;
    
    for (e in iter2) {
      var exists = false;
      
      for (i in iter1) {
        if (f(i, e)) {
          exists = true;
        }
      }
      if (!exists) {
        result = add(result, e);
      }
    }
    
    return result;
  }
  /**
    Returns an Iterable of all distinct values in `iter1` and `iter2`.
  */  
  public static function union<T>(iter1: Iterable<T>, iter2: Iterable<T>): Iterable<T> {
    return unionBy(iter1, iter2, stx.plus.Equal.getEqualFor(iter1.head()));
  }
  /**
   Produces a Tuple2 containing two Arrays, the left being elements where f(e) == true, 
   and the rest in the right.
   @param The array to partition
   @param A predicate
  */
  public static function partition<T>(iter: Iterable<T>, f: T -> Bool): Tuple2<Iterable<T>, Iterable<T>> {
    return cast Arrays.partition(iter.toArray(),f);
  }
  /**
    Produces a Tuple2 containing two Arrays, the difference from partition being that after the predicate
    returns true once, the rest of the elements will be in the right hand of the Tuple, regardless of
    the result of the predicate.
   */
  public static function partitionWhile<T>(iter: Iterable<T>, f: T -> Bool): Tuple2<Iterable<T>, Iterable<T>> { 
    return cast iter.toArray().partitionWhile(f);
  }
  /**
    Counts some property of the elements of 'arr' using a predicate. For the size of the Array @see size()
   */
  public static function count<T>(iter: Iterable<T>, f: T -> Bool): Int {
    return iter.toArray().count(f);
  } 
  /**
    Counts some property of the elements of 'arr' until the first false is returned from the predicate
   */
  public static function countWhile<T>(iter: Iterable<T>, f: T -> Bool): Int {
    return iter.toArray().countWhile(f);
  }
  /**
    Produces an Array of iter cast as an Iterable
  */
  public static function elements<T>(iter: Iterable<T>): Iterable<T> {
    return iter.toArray();
  }
  /**
    Appends the elements of ´i´ to ´arr´
   */
  public static function append<T>(iter: Iterable<T>, i: Iterable<T>): Iterable<T> {
    return Arrays.append(iter.toArray(),i);
  }
  /**
    Produces true if the Iterable is empty, false otherwise
   */
  public static function isEmpty<T>(iter: Iterable<T>): Bool {
    return !iter.iterator().hasNext();
  }
  /**
   Produces an Option Some(element) the first time the predicate returns true,
   None otherwise.
  */
  public static function find<T>(iter: Iterable<T>, f: T -> Bool): Option<T> {
    return Arrays.find(iter.toArray(),f);
  }
  /**
    Produces true if the predicate returns true for all elements, false otherwise.
   */
  public static function forAll<T>(iter: Iterable<T>, f: T -> Bool): Bool {
    return Arrays.forAll(iter.toArray(),f);
  }
  /**
    Produces true if the predicate returns true for any element, false otherwise.
   */
  public static function forAny<T>(iter: Iterable<T>, f: T -> Bool): Bool {
    return Arrays.forAny(iter.toArray(),f);
  }
  /**
    Alias for head
  */
	public static function first<T>(iter:Iterable<T>):T{
		return iter.head();
	}
  @:experimental
  /**
    Synchronous unwind of tree structure
  */
  static public function unwind<A>(root:A,children : A -> Array<A>,depth = false):Iterable<A>{
    var index = 0;
    var stack = [root];
    var visit = null;
    visit = function(x:A):Void{
      for(v in children(x)){
        visit(v);
        stack.push(v);
      }
    }
    visit(root);
    return 
      function():Option<A>{
        var val = stack[index];
        index++;
        return Options.create(val);
      }.yield();
  }
  static public function patch<A>(iter:Iterable<A>,start:Int,iter2:Iterable<A>,?length:Int = 0):Iterable<A>{
    var na      = [];
    var nums    = 0.until(iter.size());
    var itern   = nums.zip(iter);
    var size    = length == 0 ? iter2.size() : length;

    for( val in itern){
      if(val.fst() >= start && val.fst() < start + size){
        na.push(iter2.head());
        iter2 = iter2.tail();
      }else{
        na.push(val.snd());
      }
    }
    return na;
  }
}
class Lists{
  static public function toArray<T>(lst:List<T>){
    var itr : Iterable<T> = lst;
    return SIterables.toArray(itr);
  }
}