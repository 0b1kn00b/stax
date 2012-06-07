/*
/*
 HaXe library written by John A. De Goes <john@socialmedia.com>
 Contributed by Social Media Networks

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 Redistributions of source code must retain the above snapshotright notice, this list of conditions and the following disclaimer.
 Redistributions in binary form must reproduce the above snapshotright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the
 distribution.

 THIS SOFTWARE IS PROVIDED BY SOCIAL MEDIA NETWORKS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL SOCIAL MEDIA NETWORKS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package stx;

using Stax;
import Stax;


import stx.Tuples;
using stx.Tuples;

import Prelude; 

import stx.ds.plus.Equal;

using stx.Maths;
using stx.Options;

using stx.Arrays;

class Arrays { 
  /**
  * Produces a Tuple2 containing two Arrays, the left being elements where f(e) == true, 
  * and the rest in the right.
  * @param The array to partition
  * @param A predicate
  */
  public static function partition<T>(arr: Array<T>, f: T -> Bool): Tuple2<Array<T>, Array<T>> {
    return arr.foldl(Tuples.t2([], []), function(a, b) {
      if(f(b))
        a._1.push(b);
      else
        a._2.push(b);
      return a;
    });
  }
  /**
   * Produces a Tuple2 containing two Arrays, the difference from partition being that after the predicate
   * returns true once, the rest of the elements will be in the right hand of the Tuple, regardless of
   * the result of the predicate.
   */
  public static function partitionWhile<T>(arr: Array<T>, f: T -> Bool): Tuple2<Array<T>, Array<T>> {
    var partitioning = true;
    
    return arr.foldl(Tuples.t2([], []), function(a, b) {
      if (partitioning) {
        if (f(b))
          a._1.push(b);
        else {
          partitioning = false;
          a._2.push(b);
        }
      }
      else
        a._2.push(b);
      return a;
    });
  }
  /**
  * Performs a map and delivers the results to the specified 'dest'
  */
  public static function mapTo<A, B>(src: Array<A>, dest: Array<B>, f: A -> B): Array<B> {
    return src.foldl(dest.snapshot(), function(a, b) {
      a.push(f(b));
      return a;
    });
  }
  /**
  * Produces an Array from an Array of Arrays
  */
  public static function flatten<T>(arrs: Array<Array<T>>): Array<T> {
		var res : Array<T> = [];
		for (arr in arrs) {
			for (e in arr) {
				res.push(e);
			}
		}
		return res;
	}
  /**
  * Weaves an Array of arrays so that [ array0[0] , array[0] ... arrayn[0] , array0[1], array1[1] ... ]
  * Continues to operate to the length of the shortest array, and drops the rest of the elements.return
  */
  public static function interleave<T>(alls: Array<Array<T>>): Array<T> {
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
	/**
   * Performs a flatMap and delivers the reuslts to 'dest'
   */
  public static function flatMapTo<A, B>(src: Array<A>, dest: Array<B>, f: A -> Array<B>): Array<B> {
    return src.foldl(dest, function(a, b) {
			for (e  in f(b))
				a.push(e);
			return a;
    });
  }
  /**
   * Counts some property of the elements of 'arr' using a predicate. For the size of the Array @see size()
   */
  public static function count<T>(arr: Array<T>, f: T -> Bool): Int {
    return arr.foldl(0, function(a, b) {
      return a + (if (f(b)) 1 else 0);
    });
  }
  /**
   * Counts some property of the elements of 'arr' until the first false is returned from the predicate
   */
  public static function countWhile<T>(arr: Array<T>, f: T -> Bool): Int {
    var counting = true;
    
    return arr.foldl(0, function(a, b) {
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
  /**
   * Takes an initial value which is passed to function 'f' along with each element
   * one by one, accumulating the results.return
   * f(element,init)
   */
  public static function scanl<T>(arr:Array<T>, init: T, f: T -> T -> T): Array<T> {
    var accum = init;
    var result = [init];
    
    for (e in arr)
      result.push(f(e, accum));
    
    return result;
  }
  /**
   * As scanl but from the end of the Array.
   */
  public static function scanr<T>(arr:Array<T>, init: T, f: T -> T -> T): Array<T> {
    var a = arr.snapshot();
    a.reverse();
    return scanl(a, init, f);
  }
  /**
   * As scanl, but using the first element as the second parameter of 'f'
   */
  public static function scanl1<T>(arr:Array<T>, f: T -> T -> T): Array<T> {   
    var result = [];              
    if(0 == arr.length)
      return result;
    var accum = arr[0];
    result.push(accum);
    for(i in 1...arr.length)
      result.push(f(arr[i], accum));
    
    return result;
  }
  /**
   * As scanr, but using the first element as the second parameter of 'f'
   */
  public static function scanr1<T>(arr:Array<T>, f: T -> T -> T): Array<T> {
    var a = arr.snapshot();
    a.reverse();    
    return scanl1(a, f);
  }
  /**
   * Returns the Array cast as an Iterable
   */
  public static function elements<T>(arr: Array<T>): Iterable<T> {
    return arr.snapshot();
  }
  /**
   * Appends the elements of 'i' to 'arr'
   */
  public static function appendAll<T>(arr: Array<T>, i: Iterable<T>): Array<T> {
    var acc = arr.snapshot();
    
    for (e in i) 
      acc.push(e);
    
    return acc;
  }
  /**
   *^Produces true if the Array is empty, false otherwise
   */
  public static function isEmpty<T>(arr: Array<T>): Bool {
    return arr.length == 0;
  }
  /**
   * Produces an Option Some(element) the first time the predicate returns true,
   * None otherwise.
   */
  public static function find<T>(arr: Array<T>, f: T -> Bool): Option<T>{
    return arr.foldl(
		None,
		function(a, b) {
      return
		  	switch (a) {
		  		case None: Options.toOption(b).filter(f);
			 	default: a;
		    }
      }
    );
  }
  /**
   * Returns an Option Some(index) if an object reference is contain in 'arr'
   *^None otherwise
   */
  public static function findIndexOf<T>(arr: Array<T>, obj: T): Option<Int> {
	 var index = arr.indexOf(obj);
	 return if (index == -1) None else Some(index);
  }
  
  /**
   * Produces true if the predicate returns true for all elements, false otherwise.
   */
  public static function forAll<T>(arr: Array<T>, f: T -> Bool): Bool {
    return arr.foldl(true, function(a, b) {
      return switch (a) {
        case true:  f(b);
        case false: false;
      }
    });
  }
  /**
   * Produces true if the predicate returns true for any element, false otherwise.
   */
  public static function forAny<T>(arr: Array<T>, f: T -> Bool): Bool {
    return arr.foldl(false, function(a, b) {
      return switch (a) {
        case false: f(b);
        case true:  true;
      }
    });
  }
  /**
   * Determines if a value is contained in 'arr' using a predicate.
   */
  public static function exists<T>(arr: Array<T>, f: T -> Bool): Bool {
    return switch (find(arr, f)) {
      case Some(v): true;
      case None:    false;
    }
  }
  /**
   * Produces an Array with the elements in reversed order.return
   */
	public static function reversed<T>(arr: Array<T>): Array<T> {
    return IterableLambda.foldl(arr, [], function(a, b) {
      a.unshift(b);
      
      return a;
    });
  }
  /**
   * As with 'exists' but taking a second parameter in the predicate specified by 'ref'
   */
  public static function existsP<T>(arr:Array<T>, ref: T, f: T -> T -> Bool): Bool {
    var result = false;

    for (e in arr) {
      if (f(e, ref)) 
        return true;
    }
  
    return false;
  }
  /**
   * Produces an Array with no duplicate elements. Equality of the elements is determined
   * by 'f'.
   */
  public static function nubBy<T>(arr:Array<T>, f: T -> T -> Bool): Array<T> {
    return arr.foldl([], function(a: Array<T>, b: T): Array<T> {
      return if (existsP(a, b, f)) {
        a;
      }
      else {
        a.append(b);
      }
    });
  }
  /**
   * Produces an Array with no duplicate elements by comparing each element to all others.
   */
  public static function nub<T>(arr:Array<T>): Array<T> {
    return nubBy(arr, Equal.getEqualFor(arr[0]));
  }
  /**
   * Intersetcs two Arrays, determining equality by 'f'
   */  
  public static function intersectBy<T>(arr1: Array<T>, arr2: Array<T>, f: T -> T -> Bool): Array<T> {
    return arr1.foldl([], function(a: Array<T>, b: T): Array<T> {
      return if (existsP(arr2, b, f)) a.append(b); else a;
    });
  }
  /**
   * Produces an Array of elements found in both 'arr' and 'arr2'.
   */
  public static function intersect<T>(arr1: Array<T>, arr2: Array<T>): Array<T> {
    return intersectBy(arr1, arr2, Equal.getEqualFor(arr1[0]));
  }
  /**
   * Produces a Tuple2, on the left those elements before 'index', on the right those elements on or after.
   */
	public static function splitAt<T>(srcArr : Array<T>, index : Int) : Tuple2 < Array<T>, Array<T> > return
	stx.Tuples.t2(srcArr.slice(0, index),srcArr.slice(index))  
  
  /**
   * Produces the index of element 't', for a function prodcing an Option , see findIndexOf
   */
  public static function indexOf<T>(a: Array<T>, t: T): Int {
    var index = 0;
    
    for (e in a) { 
      if (e == t) return index;
      
      ++index;
    }
    
    return -1;
  } 
  /**
   * Performs a map, taking element index as a second parameter of 'f'
   */
  public static function mapWithIndex<T, S>(a: Array<T>, f: T -> Int -> S): Array<S> {
    var n: Array<S> = [];
    var i = 0;
    for (e in a) n.push(f(e, i++));
    
    return n;
  }
  /**
   * Swallows a1, returning a2
   */
  public static function then<T, S>(a1: Array<T>, a2: Array<S>): Array<S> {
    return a2;
  }
  /**
   * As with foldl but working in reverse.
   */
  public static function foldr<T, Z>(a: Array<T>, z: Z, f: T -> Z -> Z): Z {
    var r = z;
    
    for (i in 0...a.length) { 
      var e = a[a.length - 1 - i];
      
      r = f(e, r);
    }
    
    return r;
  }
  /**
   * Produces an Array of Tuple2 where Tuple2.t2(a[n],b[n]).
   */
  public static function zip<A, B>(a: Array<A>, b: Array<B>): Array<Tuple2<A, B>> {
		return zipWith(a, b, Tuples.t2);
  }
  /**
   * Produces an Array of the result of 'f' where the left parameter is a[n], and the right b[n]
   */
  public static function zipWith<A, B, C>(a: Array<A>, b: Array<B>, f : A -> B -> C): Array<C> {
    var len = Math.floor(Math.min(a.length, b.length));
    
    var r: Array<C> = [];
    
    for (i in 0...len) {
      r.push(f(a[i], b[i]));
    }
    
    return r;
  }
  /**
   * Performs a zip where the resulting tuple has the element on the left, and it's index on the right
   */
  public static function zipWithIndex<A>(a: Array<A>): Array<Tuple2<A, Int>> {
		return zipWithIndexWith(a, Tuples.t2);
  }
  /**
   * Performs a zip with the right hand parameter is the index of the element.+
   */
  public static function zipWithIndexWith<A, B>(a: Array<A>, f : A -> Int -> B): Array<B> {
    var len = a.length;
    
    var r: Array<B> = [];
    
    for (i in 0...len) {
      r.push(f(a[i], i));
    }
    
    return r;
  }
	/**
   * Adds a single element to the end of the Array.
   */
  public static function append<T>(a: Array<T>, t: T): Array<T> {
    var copy = ArrayLambda.snapshot(a);
    
    copy.push(t);
    
    return copy;
  }
  /**
   * Adds a single elements to the beginning if the Array.
   */
  public static function prepend<T>(a: Array<T>, t: T): Array<T> {
    var copy = ArrayLambda.snapshot(a);
    
    copy.unshift(t);
    
    return copy;
  } 
  /**
   * Prodcues the first element of Array 'a'.return
   */
  public static function first<T>(a: Array<T>): T {
    return a[0];
  }
  /**
   * Produces the first element of 'a' as an Option, Option.None if the Array is empty.
   */
  public static function firstOption<T>(a: Array<T>): Option<T> {
    return if (a.length == 0) None; else Some(a[0]);
  }
  /**
   * ^Produces the last element of Array 'a'
  */
  public static function last<T>(a: Array<T>): T {
    return a[a.length - 1];
  }
  /**
   * Produces the last element of 'a' as an Option, Option.None if the Array is empty.
   */
  public static function lastOption<T>(a: Array<T>): Option<T> {
    return if (a.length == 0) None; else Some(a[a.length - 1]);
  }
  
	/**
	 * Produces true if Array 'a' contains element 't'.
	 * @param t a value which may be in the array.
	 * @return bool 
	 */
  public static function contains<T>(a: Array<T>, t: T): Bool {
    for (e in a) if (t == e) return true;
    
    return false;
  }
  /**
   * Iterates Array 'a' applying function 'f' taking the element index as a second parameter
   */
  public static function foreachWithIndex<T>(a: Array<T>, f: T -> Int -> Void): Array<T> {
    var i = 0;
		for (e in a) f(e, i++);
    
    return a;
  } 
  /**
   * Produces an Array from a[0] to a[n]
   */
  public static function take<T>(a: Array<T>, n: Int): Array<T> {
    return a.slice(0, n.min(a.length));
  }
  /**
   * Produces an Array from a[0] while predicate 'p' returns true
   */
  public static function takeWhile<T>(a: Array<T>, p: T -> Bool): Array<T> {
    var r = [];
    
    for (e in a) {
      if (p(e)) r.push(e); else break;
    }
    
    return r;
  }
  /**
   * Produces an Array from a[n] to the last element of 'a'.
  */
  public static function drop<T>(a: Array<T>, n: Int): Array<T> {
    return if (n >= a.length) [] else a.slice(n);
  }
  /**
   * Drops values from Array 'a' while the predicate returns true.
   */
  public static function dropWhile<T>(a: Array<T>, p: T -> Bool): Array<T> {
    var r = [].concat(a);
    
    for (e in a) {
      if (p(e)) r.shift(); else break;
    }
    
    return r;
  }
  /**
   * Produces an Array of arrays of size 'sizeSrc'
   */
	public static function sliceBy<T>(srcArr : Array<T>, sizeSrc : Array<Int>) : Array<Array<T>> return {
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
}