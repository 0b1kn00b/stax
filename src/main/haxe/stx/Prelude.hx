package stx;

import stx.Prelude;

import Type;

using Std;

import stx.Maths;
import stx.plus.Show;

using stx.Tuples;
using stx.Prelude;
using stx.Maybes;
using stx.Strings;
using stx.plus.Show;

using stx.Prelude;

enum Unit {
  Unit;
}
typedef AnyRef = {}

typedef CodeBlock = Void -> Void

typedef Function0<R> = Void -> R
typedef Function1<P1, R> = P1 -> R
typedef Function2<P1, P2, R> = P1 -> P2 -> R
typedef Function3<P1, P2, P3, R> = P1 -> P2 -> P3 -> R
typedef Function4<P1, P2, P3, P4, R> = P1 -> P2 -> P3 -> P4 -> R
typedef Function5<P1, P2, P3, P4, P5, R> = P1 -> P2 -> P3 -> P4 -> P5 -> R
typedef Function6<P1, P2, P3, P4, P5, P6, R> = P1 -> P2 -> P3 -> P4 -> P5 -> P6 -> R
typedef Function7<P1, P2, P3, P4, P5, P6, P7, R> = P1 -> P2 -> P3 -> P4 -> P5 -> P6 -> P7 -> R
typedef Function8<P1, P2, P3, P4, P5, P6, P7, P8, R> = P1 -> P2 -> P3 -> P4 -> P5 -> P6 -> P7 -> P8 -> R
typedef Function9<P1, P2, P3, P4, P5, P6, P7, P8, P9, R> = P1 -> P2 -> P3 -> P4 -> P5 -> P6 -> P7 -> P8 -> P9 -> R
typedef Function10<P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, R> = P1 -> P2 -> P3 -> P4 -> P5 -> P6 -> P7 -> P8 -> P9 -> P10 -> R

typedef Reducer<T>    = T -> T -> T
typedef Factory<T>    = Void -> T
typedef RC<R,A>       = (A -> R) -> R
/*typedef Receive<A>    = RC<Void,A>
typedef ReceiveE<A,B> = Receive<Either<A,B>>;*/
typedef Modify<T>     = T -> T;
/**
 A function which takes no parameter and returns a result.
 */
typedef Thunk<T>    = Void -> T

/** 
		An option represents an optional value -- the value may or may not be
 		present. Maybe is a much safer alternative to null that often enables
  	reduction in code size and increase in code clarity.
 */
enum Maybe<T> {
  None;
  Some(v: T);
}
/** 
  Either represents a type that is either a "left" value or a "right" value,
  but not both. Either is often used to represent success/failure, where the
  left side represents failure, and the right side represents success.
 */
enum Either<A, B> {
  Left(v: A);
  Right(v: B);
}
enum TraversalOrder {
	PreOrder;
	InOrder;
	PostOrder;
	LevelOrder;
}
enum FreeM<A, B>{
  Cont(v:A);
  Done(v:B);
}
typedef Outcome<A>              = Either<Error,A>

typedef OrderFunction<T>  			= Function2<T, T, Int>;
typedef EqualFunction<T>  			= Function2<T, T, Bool>;
typedef ShowFunction<T>   			= Function1<T, String>;
typedef MapFunction<T> 				= Function1<T, Int>;   

typedef Lense<A, B> = {
  get : A -> B,
  set : B -> A -> A
}
@:todo('0b1kn00b','Would perhaps prefer the collection tools to be interfaces.')
typedef CollectionTools<T> = {
		order : Null<OrderFunction<T>>,
		equal	: Null<EqualFunction<T>>,
		show	: Null<ShowFunction<T>>,
		hash	: Null<MapFunction<T>>,
}
class FieldOrder {
  public static inline var Ascending	 	= 1;
  public static inline var Descending 	= -1;
  public static inline var Ignore 			= 0;
}

class Prelude{
  /**
    Creates PosInfos for the position where called
  */
  public static function here(?pos:haxe.PosInfos) {
    return pos;
  }
  inline static public  function tool<A>(?order:OrderFunction<A>,?equal:EqualFunction<A>,?hash:MapFunction<A>,?show:ShowFunction<A>):CollectionTools<A>{
    return { order : order , equal : equal , show : show , hash : hash };
  }
  
  static public function unfold<T, R>(initial: T, unfolder: T -> Maybe<Tuple2<T, R>>): Iterable<R> {
    return {
      iterator: function(): Iterator<R> {
        var _next: Maybe<R> = None;
        var _progress: T = initial;

        var precomputeNext = function() {
          switch (unfolder(_progress)) {
            case None:
              _progress = null;
              _next     = None;

            case Some(tuple):
              _progress = tuple.fst();
              _next     = Some(tuple.snd());
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
  
  static public function error<T>(?pos:haxe.PosInfos): String -> T { 
    return 
      function(msg: String):T{
        throw '$msg at $pos';  return null;
      }
  }
  static public function err<T>(?pos:haxe.PosInfos): Error->T{
    return 
      function(err:Error):T{
        throw(err);
        return null;
      }
  }
}


class SIterables{
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
  static public function foreach<T>(iter : Iterable<T>, f : T-> Void ):Void {
    for (e in iter) f(e);
  }
}
class SArrays {
  /**
    Applies function f to each element in a, returning the results
  */
  inline static public function map<T, S>(a: Array<T>, f: T -> S): Array<S> {
    var n: Array<S> = [];
    
    for (e in a) n.push(f(e));
    
    return n;
  }
  /**
    Applies function f to each element in a, appending and returning the results.
  */
  static public function flatMap<T, S>(a: Array<T>, f: T -> Iterable<S>): Array<S> {
    var n: Array<S> = [];
    
    for (e1 in a) {
      for (e2 in f(e1)) n.push(e2);
    }
    
    return n;
  }
  /**
    Using starting var z, run f on each element, storing the result, and passing that result 
    into the next call.
      [1,2,3,4,5].foldl( 100, function(init,v) return init + v ));//(((((100 + 1) + 2) + 3) + 4) + 5)
  */
  static public function foldl<T, Z>(a: Array<T>, z: Z, f: Z -> T -> Z): Z {
    var r = z;
    
    for (e in a) { r = f(r, e); }
    
    return r;
  }
  /**
    Call f on each element in a, returning a collection where f(e) = true
  */
  static public function filter<T>(a: Array<T>, f: T -> Bool): Array<T> {
    var n: Array<T> = [];
    
    for (e in a)
      if (f(e)) n.push(e);
    
    return n;
  }
  /**
    Returns the size of a
  */
  static public function size<T>(a: Array<T>): Int {
    return a.length;
  }
  /**
    Returns a copt of a.
  */
  static public function snapshot<T>(a: Array<T>): Array<T> {
    return [].concat(a);
  }
  /**
    Apply f to each element in a.
  */
  static public function foreach<T>(a: Array<T>, f: T -> Void): Array<T> {
    for (e in a) f(e);
    
    return a;
  }
}
class IntIterators {
  /**
    Creates an Iterable 0...n
  */
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
  /**
    Creates an Iterable 0...(n-1)
  */
  static public function until(start: Int, end: Int): Iterable<Int> {
    return to(start, end - 1);
  }
}