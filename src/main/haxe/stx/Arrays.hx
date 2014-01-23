package stx;

using Prelude;

import stx.type.*;

import stx.Equal;

using stx.Tuples;
using stx.Maths;
using stx.Option;
using stx.Functions;
using stx.Arrays;

class Arrays {
  /*static public function bindFold<R,A,B,M>(arr:Array<A>,pure:B->M,init:B,bind:M->(B->M)->M,fold:B->A->B){
    return stx.Arrays.foldLeft(arr,
      pure(init),
      function(memo:M,next:A){
        return bind(memo,
          function(b:B){
            return fold(b,next);
          }
        );
      }
    );
  }*/
  static public function fold<A,Z>(arr:Array<A>,zero:Thunk<Z>,unit:A->Z,plus:Z->Z->Z):Z{
    return arr.foldLeft(
      zero(),
      function(memo,next){
        return plus(memo,unit(next));
      }
    );
  }
  @doc("Call f on each element in a, returning a collection where f(e) = true.")
  static public function filter<T>(a: Array<T>, f: T -> Bool): Array<T> {
    var n: Array<T> = [];
    
    for (e in a)
      if (f(e)) n.push(e);
    
    return n;
  }
  @doc("Return true if length is greater than 1.")
  static public function isDefined<T>(a:Array<T>):Bool{
    return a.length > 0;
  }
  @doc("Apply f to each element in a.")
  static public function each<T>(a: Array<T>, f: T -> Void): Array<T> {
    for (e in a) f(e);
    
    return a;
  }
  @doc("Applies function f to each element in a, returning the results.")
  inline static public function map<T, S>(a: Array<T>, f: T -> S): Array<S> {
    var n: Array<S> = [];
      
    for (e in a) n.push(f(e));
      
    return n;
  }
  @doc("
    Using starting var z, run f on each element, storing the result, and passing that result 
    into the next call:

        [1,2,3,4,5].foldLeft( 100, function(init,v) return init + v ));//(((((100 + 1) + 2) + 3) + 4) + 5)
  ")
  static public function foldLeft<T, Z>(a: Array<T>, z: Z, f: Z -> T -> Z): Z {
    var r = z;
    
    for (e in a) { r = f(r, e); }
    
    return r;
  }
  @doc("create an empty Array.")
  @:noUsing static public function create<A>():Array<A>{
    return [];
  }
  @doc("unit function.")
  static public function unit<A>():Array<A>{
    return [];
  }
  @doc("create an Array with the element `v`.")
  @:noUsing static public function one<A>(v:A):Array<A>{
    return [v];
  }
  @doc("set `v` at index `i` of `arr`.")
  static public function set<A>(arr:Array<A>,i:Int,v:A):Array<A>{
    arr     = arr.copy();
    arr[i]  = v;
    return arr;
  }
  @doc("return element of `arr` at index `i`")
  static public function get<A>(arr:Array<A>,i:Int):A{
    return arr[i];
  }
  @doc("Performs a `foldLeft`, using the first value of `arr` as the `memo` value.")
   static public function foldLeft1<T>(arr: Array<T>, mapper: T -> T -> T): T {
    var folded = arr.first();
    switch (Iterables.tailOption(arr)) {
      case Some(v)  :
        for (e in v) { folded = mapper(folded, e); }
      default       :
    }
    return folded;
  }
  @doc("Produces a `Tuple2` containing two `Array`, the left being elements where `f(e) == true`, the rest in the right.")
  @params('The array to partition','A predicate')
  static public function partition<T>(arr: Array<T>, f: T -> Bool): Tuple2<Array<T>, Array<T>> {
    return arr.foldLeft(tuple2([], []), function(a, b) {
      if(f(b))
        a.fst().push(b);
      else
        a.snd().push(b);
      return a;
    });
  }
  @doc("
    Produces a `Tuple2` containing two `Arrays`, the difference from partition being that after the predicate
    returns true once, the rest of the elements will be in the right hand of the tuple, regardless of
    the result of the predicate.
  ")
  static public function partitionWhile<T>(arr: Array<T>, f: T -> Bool): Tuple2<Array<T>, Array<T>> {
    var partitioning = true;
    
    return arr.foldLeft(tuple2([], []), function(a, b) {
      if (partitioning) {
        if (f(b))
          a.fst().push(b);
        else {
          partitioning = false;
          a.snd().push(b);
        }
      }
      else
        a.snd().push(b);
      return a;
    });
  }
  @doc("Performs a `map` and delivers the results to the specified `dest`.")
  static public function mapTo<A, B>(src: Array<A>, dest: Array<B>, f: A -> B): Array<B> {
    return src.foldLeft(dest.snapshot(), function(a, b) {
      a.push(f(b));
      return a;
    });
  }
  @doc("Produces an Array from an Array of Arrays.")
  static public function flatten<T>(arrs: Array<Array<T>>): Array<T> {
    var res : Array<T> = [];
    for (arr in arrs) {
      for (e in arr) {
        res.push(e);
      }
    }
    return res;
  }
  @doc("
   Weaves an `Array` of arrays so that `[ array0[0] , array1[0] ... arrayn[0] , array0[1], array1[1] ... ]`
   Continues to operate to the length of the shortest array, and drops the rest of the elements.
  ")
  static public function interleave<T>(alls: Array<Array<T>>): Array<T> {
    var res = [];   
    if (alls.length > 0) {
      var length = {
        var minLength = alls[0].length.toFloat();
        for (e in alls)
          minLength = Math.min(minLength, e.length.toFloat());
        minLength.int();
      }
      var i = 0;
      while (i < length) {
        for (arr in alls)
          res.push(arr[i]);
        i++;
      }
    }
    return res;
  }
  @doc("
    Applies function f to each element in a, appending and returning the results.
  ")
  static public function flatMap<T, S>(a:Array<T>, f:T->Iterable<S>):Array<S> {
    var n: Array<S> = [];
    
    for (e1 in a) {
      for (e2 in f(e1)) n.push(e2);
    }
    
    return n;
  }
  @doc("Performs a `flatMap` and delivers the reuslts to `dest`.")
  static public function flatMapTo<A, B>(src: Array<A>, dest: Array<B>, f: A -> Array<B>): Array<B> {
    return src.foldLeft(dest, function(a, b) {
      for (e  in f(b))
        a.push(e);
      return a;
    });
  }
  @doc("
    Counts some property of the elements of `arr` using a predicate. For the size of the Array @see `size()`
   ")
  static public function count<T>(arr: Array<T>, f: T -> Bool): Int {
    return arr.foldLeft(0, function(a, b) {
      return a + (if (f(b)) 1 else 0);
    });
  }
  @doc("Counts some property of the elements of `arr` until the first `false` is returned from the predicate")
  static public function countWhile<T>(arr: Array<T>, f: T -> Bool): Int {
    var counting = true;
    
    return arr.foldLeft(0, function(a, b) {
      return if (!counting) a;
      else {
        if (f(b)) a + 1;
        else {
          counting = false;
          
          a;
        }
      }
    });
  }
  @doc("
    Takes an initial value which is passed to function `f` along with each element
    one by one, accumulating the results.
    f(next,memo)
   ")
  static public function scanl<T>(arr:Array<T>, init: T, f: T -> T -> T): Array<T> {
    var accum = init;
    var result = [init];
    
    for (e in arr)
      result.push(f(e, accum));
    
    return result;
  }
  @doc("As `scanl` but from the end of the Array.")
  static public function scanr<T>(arr:Array<T>, init: T, f: T -> T -> T): Array<T> {
    var a = arr.snapshot();
    a.reverse();
    return scanl(a, init, f);
  }
  @doc("As scanl, but using the first element as the second parameter of `f`")
  static public function scanl1<T>(arr:Array<T>, f: T -> T -> T): Array<T> {   
    var result = [];              
    if(0 == arr.length)
      return result;
    var accum = arr[0];
    result.push(accum);
    for(i in 1...arr.length)
      result.push(f(arr[i], accum));
    
    return result;
  }
  @doc("As scanr, but using the first element as the second parameter of `f`")
  static public function scanr1<T>(arr:Array<T>, f: T -> T -> T): Array<T> {
    var a = arr.snapshot();
    a.reverse();    
    return scanl1(a, f);
  }
  @doc("Returns the Array cast as an Iterable.")
  static public function elements<T>(arr: Array<T>): Iterable<T> {
    return arr.snapshot();
  }
  @doc("Appends the elements of `i` to `arr`")
  static public function append<T>(arr: Array<T>, i: Iterable<T>): Array<T> {
    var acc = arr.snapshot();
    
    for (e in i) 
      acc.push(e);
    
    return acc;
  }
  @doc("Produces `true` if the Array is empty, `false` otherwise")
  static public function isEmpty<T>(arr: Array<T>): Bool {
    return arr.length == 0;
  }
  @doc("Produces `true` if the Array is empty, `false` otherwise")
  static public function containsValues<T>(arr: Array<T>): Bool {
    return arr.length > 0;
  }
  @doc("
    Produces an `Option.Some(element)` the first time the predicate returns `true`,
    `None` otherwise.
   ")
  static public function search<T>(arr: Array<T>, f: T -> Bool): Option<T>{
    return arr.foldLeft(
    None,
    function(a, b) {
      return
        switch (a) {
          case None: Options.create(b).filter(f);
        default: a;
        }
      }
    );
  }
  @doc("searches for `v` in `arr` using a predicate from `stx.Equal`")
  static public function find<T>(arr: Array<T>,v : T) : Option<T>{
    var _eq = Equal.getEqualFor(v);
    return search(arr,_eq.bind(v));
  }
  @doc("Returns an `Option.Some(index)` if an object reference is contained in `arr`, `None` otherwise.")
  static public function findIndexOf<T>(arr: Array<T>, obj: T): Option<Int> {
   var index = arr.indexOf(obj);
   return if (index == -1) None else Some(index);
  }
  
  @doc("
   Returns an Array that contains all elements from a which are not elements of b.
    If a contains duplicates, the resulting Array contains duplicates.
  ")
  public static function difference<T>(a:Array<T>, b:Array<T>, eq:T->T->Bool){
    var res = [];
    for (e in a) {
      if (!any(b, function (x) return eq(x, e))) res.push(e);
    }
    return res;
  }
  public static function shuffle <T>(arr: Array<T>): Array<T>{
    var res = [];
    var cp = arr.copy();
    while (cp.length > 0) {
      var randIndex = Math.floor(Math.random()*cp.length);
      res.push(cp.splice(randIndex,1)[0]);
    }
    return res;
  }
  @doc("
    Returns an Array that contains all elements from a which are also elements of b.
    If a contains duplicates, so will the result.
  ")
  public static function union <T>(a:Array<T>, b:Array<T>, eq:T->T->Bool) 
  {
    var res = [];
    for (e in a) {
      res.push(e);
    }
    for (e in b) {
      if (!any(res, function (x) return eq(x, e))) res.push(e);
    }
    return res;
  }

  @doc("Produces `true` if the predicate returns `true` for all elements, `false` otherwise.")
  static public function all<T>(arr: Array<T>, f: T -> Bool): Bool {
    return arr.foldLeft(true, function(a, b) {
      return switch (a) {
        case true:  f(b);
        case false: false;
      }
    });
  }
  @doc("Produces `true` if the predicate returns `true` for *any* element, `false` otherwise.")
  static public function any<T>(arr: Array<T>, f: T -> Bool): Bool {
    return arr.foldLeft(false, function(a, b) {
      return switch (a) {
        case false: f(b);
        case true:  true;
      }
    });
  }
  @doc("Determines if a value is contained in `arr` using a predicate.")
  static public function exists<T>(arr: Array<T>, f: T -> Bool): Bool {
    return switch (search(arr, f)) {
      case Some(_): true;
      case None:    false;
    }
  }
  @doc("As with `exists` but taking a second parameter in the predicate specified by `ref`")
  static public function existsP<T>(arr:Array<T>, ref: T, f: T -> T -> Bool): Bool {
    var result = false;

    for (e in arr) {
      if (f(e, ref)) 
        return true;
    }
  
    return false;
  }
  @doc("Produces an Array with no duplicate elements. Equality of the elements is determined by `f`.")
  static public function nubBy<T>(arr:Array<T>, f: T -> T -> Bool): Array<T> {
    return arr.foldLeft([], function(a: Array<T>, b: T): Array<T> {
      return if (existsP(a, b, f)) {
        a;
      }
      else {
        a.add(b);
      }
    });
  }
  @doc("Produces an Array with no duplicate elements by comparing each element to all others.")
  static public function nub<T>(arr:Array<T>): Array<T> {
    return nubBy(arr, Equal.getEqualFor(arr[0]));
  }
  /*static public function union<T>(arr0:Array<T>,arr1:Array<T>):Array<T>{
    return arr0.append(arr1).nub();
  }
  static public function unionBy<T>(arr0:Array<T>,arr1:Array<T>,f:T->T->T):Array<T>{
    return arr0.append(arr1).nubBy(f);
  }*/
  @doc("Intersects two Arrays, determining equality by `f`.")
  static public function intersectBy<T>(arr1: Array<T>, arr2: Array<T>, f: T -> T -> Bool): Array<T> {
    return arr1.foldLeft([], function(a: Array<T>, b: T): Array<T> {
      return if (existsP(arr2, b, f)) a.add(b); else a;
    });
  }
  @doc("Produces an Array of elements found in both `arr` and `arr2`.")
  static public function intersect<T>(arr1: Array<T>, arr2: Array<T>): Array<T> {
    return intersectBy(arr1, arr2, Equal.getEqualFor(arr1[0]));
  }
  @doc("Produces a `Tuple2`, on the left those elements before `index`, on the right those elements on or after.")
  static public function splitAt<T>(srcArr : Array<T>, index : Int) : Tuple2 < Array<T>, Array<T> > return
  tuple2(srcArr.slice(0, index),srcArr.slice(index));
  
  @doc("Produces the index of element `t`. For a function producing an `Option`, see `findIndexOf`.")
  static public function indexOf<T>(a: Array<T>, t: T): Int {
    var index = 0;
    
    for (e in a) { 
      if (e == t) return index;
      
      ++index;
    }
    
    return -1;
  } 
  @doc("Produces an Array of Tuple2 containing the value and it's index.")
  static public function withIndex<A>(a:Array<A>):Array<Tuple2<A,Int>>{
    var o = [];
    for(i in 0...a.length){
      o.push( tuple2( a[i] , i ) );
    }
    return o;
  }
  @doc("Performs a `map`, taking element index as a second parameter of `f`")
  static public function mapWithIndex<T, S>(a: Array<T>, f: T -> Int -> S): Array<S> {
    var n: Array<S> = [];
    var i = 0;
    for (e in a) n.push(f(e, i++));
    
    return n;
  }
  @doc("As with `foldLeft` but working from the right hand side.")
  static public function foldRight<T, Z>(a: Array<T>, z: Z, f: T -> Z -> Z): Z {
    var r = z;
    
    for (i in 0...a.length) { 
      var e = a[a.length - 1 - i];
      
      r = f(e, r);
    }
    
    return r;
  }
  @doc("Produces an `Array` of `Tuple2` where `Tuple2.t2(a[n],b[n]).`")
  static public function zip<A, B>(a: Array<A>, b: Array<B>): Array<Tuple2<A, B>> {
    return zipWith(a, b, tuple2);
  }
  @doc("Produces an `Array` of the result of `f` where the left parameter is `a[n]`, and the right: `b[n]`")
  static public function zipWith<A, B, C>(a: Array<A>, b: Array<B>, f : A -> B -> C): Array<C> {
    var len = Math.floor(Math.min(a.length, b.length));
    
    var r: Array<C> = [];
    
    for (i in 0...len) {
      r.push(f(a[i], b[i]));
    }
    
    return r;
  }
  @doc("Performs a `zip` where the resulting `Tuple2` has the element on the left, and it's index on the right")
  static public function zipWithIndex<A>(a: Array<A>): Array<Tuple2<A, Int>> {
    return zipWithIndexWith(a, tuple2);
  }
  @doc("Performs a `zip` with the right hand parameter is the index of the element.")
  static public function zipWithIndexWith<A, B>(a: Array<A>, f : A -> Int -> B): Array<B> {
    var len = a.length;
    var r: Array<B> = [];
    
    for (i in 0...len) {
      r.push(f(a[i], i));
    }
    
    return r;
  }
  @doc("Adds a single element to the end of the Array.")
  static public function add<T>(a: Array<T>, t: T): Array<T> {
    var copy = snapshot(a);
    
    copy.push(t);
    
    return copy;
  }
  @doc("Adds a single elements to the beginning if the Array.")
  static public function cons<T>(a: Array<T>, t: T): Array<T> {
    var copy = snapshot(a);
    
    copy.unshift(t);
    
    return copy;
  } 
  @doc("Produces the first element of Array `a`.")
  static public function first<T>(a: Array<T>): T {
    return a[0];
  }
  @doc("Produces the first element of `a` as an `Option`, `Option.None` if the `Array` is empty.")
  static public function firstOption<T>(a: Array<T>): Option<T> {
    return if (a.length == 0) None; else Some(a[0]);
  }
  @doc("Produces the last element of Array `a`")
  static public function last<T>(a: Array<T>): T {
    return a[a.length - 1];
  }
  @doc("Produces the last element of `a` as an `Option`, `Option.None` if the `Array` is empty.")
  static public function lastOption<T>(a: Array<T>): Option<T> {
    return if (a.length == 0) None; else Some(a[a.length - 1]);
  }
  
  @doc("Produces `true` if Array `a` contains element `t`")
  @params('an array','A value which may be in the array.')
  static public function contains<T>(a: Array<T>, t: T): Bool {
    for (e in a) if (t == e) return true;
    
    return false;
  }
  @doc("Iterates `Array` `a`, applying function `f`, taking the element index as a second parameter")
  static public function eachWithIndex<T>(a: Array<T>, f: T -> Int -> Void): Array<T> {
    var i = 0;
    for (e in a) f(e, i++);
    
    return a;
  } 
  @doc("Produces an `Array` from `a[0]` to `a[n]`")
  static public function take<T>(a: Array<T>, n: Int): Array<T> {
    return a.slice(0, n.min(a.length));
  }
  @doc("Produces an Array from `a[0]` while predicate `p` returns `true`")
  static public function takeWhile<T>(a: Array<T>, p: T -> Bool): Array<T> {
    var r = [];
    

    for (e in a) {
      if (p(e)) r.push(e); else break;
    }
    
    return r;
  }
  @doc("Produces an Array from `a[n]` to the last element of `a`.")
  static public function dropLeft<T>(a: Array<T>, n: Int): Array<T> {
    return if (n >= a.length) [] else a.slice(n);
  }
  @doc("Produces an Array from `a[0]` to a[a.length-n].")
  static public function dropRight<T>(a: Array<T>, n: Int): Array<T> {
    return if (n >= a.length) [] else a.slice(0,a.length - n);
  }
  @doc("Drops values from Array `a` while the predicate returns true.")
  static public function dropWhile<T>(a: Array<T>, p: T -> Bool): Array<T> {
    var r = [].concat(a);
    
    for (e in a) {
      if (p(e)) r.shift(); else break;
    }
    
    return r;
  }
  @doc("Produces an Array with the elements in reversed order")
  static public function reversed<T>(arr: Array<T>): Array<T> {
    return Iterables.foldLeft(arr, [], function(a, b) {
      a.unshift(b);
      
      return a;
    });
  }
  @doc("Produces an Array of arrays of size `sizeSrc`")
  static public function sliceBy<T>(srcArr : Array<T>, sizeSrc : Array<Int>) : Array<Array<T>> return {
    var slices = [];    
    var restIndex = 0;
    for (size in sizeSrc) {
      var newRestIndex = restIndex + size;
      var slice = srcArr.slice(restIndex, newRestIndex);
      slices.push(slice);
      restIndex = newRestIndex;
    }
    slices;
  }
  @doc('Produces a map')
  static public function toMap<V>(arr:Array<Tuple2<String,V>>):Map<String,V>{
    var mp = new haxe.ds.StringMap();
    arr.each(function(l,r){mp.set(l,r);}.tupled());
    return mp;
  }
  @doc("Pads out to len, ignores if len is less than Array length.")
  static public function pad<T>(arr:Array<T>,len:Int):Array<T>{
    var len0 = len - arr.length;
    var arr0 = [];
    for (i in 0...len0){
      arr0.push(null);
    }
    return arr.append(arr0);
  }
  @doc("Fills `null` values in `arr` with `def`.")
  static public function fill<T>(arr:Array<T>,def:T):Array<T>{
    return arr.map(
      function(x){
        return x == null ? def : x;
      }
    );
  }
  static public function and<A>(arr0:Array<A>,arr1:Array<A>):Bool{
    var eq = null;
    var geq = function(x:A,y:A){ return eq == null ? Equal.getEqualFor(x == null ? y : x ) : eq; }
    return arr0.zip(arr1).foldLeft(true,
      function(memo:Bool,next:Tuple2<A,A>){
        return memo ? geq(next.fst(),next.snd())(next.fst(),next.snd()) : memo;
      }
    );
  }
  static public function rotate<A>(arr0:Array<A>,num:Int):Array<A>{
    num = num%arr0.length;
    var l = arr0.take(num);
    var r = arr0.dropLeft(num);
    return if(num < 0){  
      r.append(l);
    }else if(num > 1){
      r.append(l);
    }else{
      arr0;
    }
  }
  @doc("Returns the size of a")
  static public function size<T>(a: Array<T>): Int {
    return a.length;
  }
  @doc("Returns a copy of a.")
  static public function snapshot<T>(a: Array<T>): Array<T> {
    return [].concat(a);
  }
/*  static public function difference<T>(arr0:Array<T>,arr1:Array<T>):Array<T>{
    var o   = [];
    var eq0 = arr0.firstOption().map(Equal.getEqualFor);
    var eq1 = arr1.firstOption().map(Equal.getEqualFor);
    var eq2 = eq0.orElse(function() return eq1);
    if (eq.isEmpty()) return [];
    var eq  = eq2.get();
    return null;
  }*/
}