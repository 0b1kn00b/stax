package ;

/**
 * ...
 * @author 0b1kn00b
 */

import stx.Tuples;
import Prelude;

import Type;

import stx.Maths;
import stx.ds.plus.Show;

using Prelude;
using Stax;
using stx.Options;
using stx.Strings;
using stx.ds.plus.Show;

class Stax {
	inline static public  function tool<A>(?order:OrderFunction<A>,?equal:EqualFunction<A>,?hash:HashFunction<A>,?show:ShowFunction<A>):CollectionTools<A>{
		return { order : order , equal : equal , show : show , hash : hash };
	}
  static public function noop0(){
    return function(){};
  }  
  static public function noop1<A>() {
    return function(a: A) { }
  }
  static public function noop2<A, B>() {
    return function(a: A, b: B) { }
  }
  static public function noop3<A, B, C>() {
    return function(a: A, b: B, c: C) { }
  }
  static public function noop4<A, B, C, D>() {
    return function(a: A, b: B, c: C, d: D) { }
  }
  static public function noop5<A, B, C, D, E>() {
    return function(a: A, b: B, c: C, d: D, e: E) { }
  }
  static public function identity<A>(): Function1<A, A> {
    return function(a: A) { return a; }
  }
  static public function unfold<T, R>(initial: T, unfolder: T -> Option<Tuple2<T, R>>): Iterable<R> {
    return {
      iterator: function(): Iterator<R> {
        var _next: Option<R> = None;
        var _progress: T = initial;

        var precomputeNext = function() {
          switch (unfolder(_progress)) {
            case None:
              _progress = null;
              _next     = None;

            case Some(tuple):
              _progress = tuple._1;
              _next     = Some(tuple._2);
          }
        }

        precomputeNext();

        return {
          hasNext: function(): Bool {
            return !_next.isEmpty();
          },

          next: function(): R {
            var n = _next.get();

            precomputeNext();

            return n;
          }
        }
      }
    }
  }
	
  static public function error<T>(msg: String): T { throw msg;  return null; }
}

class ArrayLambda {
	inline static public function map<T, S>(a: Array<T>, f: T -> S): Array<S> {
    var n: Array<S> = [];
    
    for (e in a) n.push(f(e));
    
    return n;
  }
	inline static public function flatMap<T, S>(a: Array<T>, f: T -> Iterable<S>): Array<S> {
    var n: Array<S> = [];
    
    for (e1 in a) {
      for (e2 in f(e1)) n.push(e2);
    }
    
    return n;
  }
	inline static public function foldl<T, Z>(a: Array<T>, z: Z, f: Z -> T -> Z): Z {
    var r = z;
    
    for (e in a) { r = f(r, e); }
    
    return r;
  }
	inline static public function filter<T>(a: Array<T>, f: T -> Bool): Array<T> {
    var n: Array<T> = [];
    
    for (e in a)
      if (f(e)) n.push(e);
    
    return n;
  }
	
	static public function size<T>(a: Array<T>): Int {
    return a.length;
  }
	static public function snapshot<T>(a: Array<T>): Array<T> {
    return [].concat(a);
  }
	static public function foreach<T>(a: Array<T>, f: T -> Void): Array<T> {
    for (e in a) f(e);
    
    return a;
  }
}
class IterableLambda{
	inline static public function toArray<T>(i: Iterable<T>) {
    var a = [];
    for (e in i) a.push(e);
    return a;
  }
	static public function toIterable<T>(it:Iterator<T>):Iterable<T> {
		return {
			iterator : function () {
				return {
						next 			: it.next,
						hasNext		: it.hasNext
				}
			}
		}
	}
	static public function map<T, Z>(iter: Iterable<T>, f: T -> Z): Iterable<Z> {
    return foldl(iter, [], function(a, b) {
      a.push(f(b));
      return a;
    });
  }
  
  static public function flatMap<T, Z>(iter: Iterable<T>, f: T -> Iterable<Z>): Iterable<Z> {
    return foldl(iter, [], function(a, b) {
      for (e in f(b)) a.push(e);
      return a;
    });
  }  
	static public function foldl<T, Z>(iter: Iterable<T>, seed: Z, mapper: Z -> T -> Z): Z {
    var folded = seed;
    
    for (e in iter) { folded = mapper(folded, e); }
    
    return folded;
  }   
  static public function filter<T>(iter: Iterable<T>, f: T -> Bool): Iterable<T> {
    return ArrayLambda.filter(iter.toArray(), f);
  }
	static public function size<T>(iterable: Iterable<T>): Int {
    var size = 0;
    
    for (e in iterable) ++size;
    
    return size;
  }
	static public function foreach<T>(iter : Iterable<T>, f : T-> Void ):Void {
    for (e in iter) f(e);
	}
}
class IntIters {
	static public function to(start: Int, end: Int): Iterable<Int> {
    return {
      iterator: function() {
        var cur = start;
    
        return {
          hasNext: function(): Bool { return cur <= end; },      
          next:    function(): Int  { var next = cur; ++cur; return next; }
        }
      }
    }
  }
  
  static public function until(start: Int, end: Int): Iterable<Int> {
    return to(start, end - 1);
  }
}
