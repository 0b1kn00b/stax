package stx;

using stx.Strings;
using stx.Functions;
using stx.Iterables;

import stx.Prelude;

typedef Predicate<A>              = Predicate1<A>
typedef Predicate1<A>             = Function<A, Bool>
typedef Predicate2<A, B>          = Function2<A, B, Bool>
typedef Predicate3<A, B, C>       = Function3<A, B, C, Bool>
typedef Predicate4<A, B, C, D>    = Function4<A, B, C, D, Bool>
typedef Predicate5<A, B, C, D, E> = Function5<A, B, C, D, E, Bool>

class Predicates {
  /**
    Produces a predicate that succeeds on any input
  */
  static public function isAny<A>() : Predicate<A>{
    return 
      function(value){
        return true;
      }
  }
  /**
    Produces a predicate that succeeds on a null input
  */
  static public function isNull<T>(): Predicate<T> {
    return function(value) {
      return value == null;
    }
  }
  /**
    Produces a predicate that succeeds on a non null input.
  */
  static public function isNotNull<T>(): Predicate<T> {
    return function(value) {
      return value != null;
    }
  }
  /**
    Produces a predicate that succeeds if the input is greater than `ref`.
  */
  static public function isGreaterThan(ref: Float): Predicate<Float> {
    return function(value) {
      return value > ref;
    }
  }
  /**
    Produces a predicate that succeeds if the input is less than `ref`.
  */
  static public function isLessThan(ref: Float): Predicate<Float> {
    return function(value) {
      return value < ref;
    }
  }
  /**
    Produces a predicate that succeeds if the input is greater than `ref`.
  */
  static public function isGreaterThanInt(ref: Int): Predicate<Int> {
    return function(value) {
      return value > ref;
    }
  }
  /**
    Produces a predicate that succeeds if the input is less than `ref`.
  */
  static public function isLessThanInt(ref: Int): Predicate<Int> {
    return function(value) {
      return value < ref;
    }
  }
  /**
    Produces a predicate that succeeds if the input is equal to ref.
  */
  static public function isEqualTo<T>(ref: T, ?equal: EqualFunction<T>): Predicate<T> {
    if (equal == null) equal = stx.plus.Equal.getEqualFor(ref);
    
    return function(value) {
      return equal(ref, value);
    }
  }
  /**
    Produces a predicate that succeeds if the input is contained in `vals`.
  */
  static public function isOneOf<A>(vals:Iterable<A>,?equal: EqualFunction<A>):Predicate<A>{
    return 
      function(x:A){
        return vals.forAny( isEqualTo(x,equal) );
      }
  }
  static public function isAlike(e:EnumValue):Predicate<EnumValue>{
    return Enums.alike.p1(e);
  }
  /**
    Produces a predicate that succeeds if both input predicates succeed.
  */
  static public function and<T>(p1: Predicate<T>, p2: Predicate<T>): Predicate<T> {
    return function(value) {
      return p1(value) && p2(value);
    }
  }
  /**
    Produces a predicate that succeeds if all input predicates succeed.
  */
  static public function andAll<T>(p1: Predicate<T>, ps: Iterable<Predicate<T>>): Predicate<T> {
    return function(value) {
      var result = p1(value);
      
      for (p in ps) {
        if (!result) break;
        
        result = result && p(value);
      }
      
      return result;
    }
  }
  /**
    Produces a predicate that succeeds if one or other predicates succeed.
  */
  static public function or<T>(p1: Predicate<T>, p2: Predicate<T>): Predicate<T> {
    return function(value:T) {
      return p1(value) || p2(value);
    }
  }
  /**
    Produces a predicate that succeeds if the input predicate fails.
  */
  static public function not<T>(p1: Predicate<T>):Predicate<T>{
    return 
      function(value:T){
        return !p1(value);
      }
  }  
  /**
    Produces a predicate that succeeds if any of the input predicates succeeds.
  */
  static public function orAny<T>(p1: Predicate<T>, ps: Iterable<Predicate<T>>): Predicate<T> {
    return function(value) {
      var result = p1(value);
      
      for (p in ps) {
        if (result) break;
        
        result = result || p(value);
      }
      
      return result;
    }
  }
}