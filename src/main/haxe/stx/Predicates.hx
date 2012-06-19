package stx;
using stx.Strings;
import stx.Prelude;

class Predicates {
  public static function isNull<T>(): Predicate<T> {
    return function(value) {
      return value == null;
    }
  }
  
  public static function isNotNull<T>(): Predicate<T> {
    return function(value) {
      return value != null;
    }
  }
  
  public static function isGreaterThan(ref: Float): Predicate<Float> {
    return function(value) {
      return value > ref;
    }
  }
  
  public static function isLessThan(ref: Float): Predicate<Float> {
    return function(value) {
      return value < ref;
    }
  }
  
  public static function isGreaterThanInt(ref: Int): Predicate<Int> {
    return function(value) {
      return value > ref;
    }
  }
  
  public static function isLessThanInt(ref: Int): Predicate<Int> {
    return function(value) {
      return value < ref;
    }
  }
  
  public static function isEqualTo<T>(ref: T, ?equal: EqualFunction<T>): Predicate<T> {
    if (equal == null) equal = stx.ds.plus.Equal.getEqualFor(ref);
    
    return function(value) {
      return equal(ref, value);
    }
  }
  
  public static function and<T>(p1: Predicate<T>, p2: Predicate<T>): Predicate<T> {
    return function(value) {
      return p1(value) && p2(value);
    }
  }
  
  public static function andAll<T>(p1: Predicate<T>, ps: Iterable<Predicate<T>>): Predicate<T> {
    return function(value) {
      var result = p1(value);
      
      for (p in ps) {
        if (!result) break;
        
        result = result && p(value);
      }
      
      return result;
    }
  }
  
  public static function or<T>(p1: Predicate<T>, p2: Predicate<T>): Predicate<T> {
    return function(value:T) {
      return p1(value) || p2(value);
    }
  }
  public static function not<T>(p1: Predicate<T>):Predicate<T>{
    return 
      function(value:T){
        return !p1(value);
      }
  }  
  public static function orAny<T>(p1: Predicate<T>, ps: Iterable<Predicate<T>>): Predicate<T> {
    return function(value) {
      var result = p1(value);
      
      for (p in ps) {
        if (result) break;
        
        result = result || p(value);
      }
      
      return result;
    }
  }
  
  public static function negate<T>(p: Predicate<T>): Predicate<T> {
    return function(value) {
      return !p(value);
    }
  }
}
class StringPredicates{
  public static function startsWith(s: String): Predicate<String> {
    return function(value: String) {
      return value.startsWith(s);
    }
  }
  
  public static function endsWith(s: String): Predicate<String> {
    return function(value: String) {
      return value.endsWith(s);
    }
  }
  
  public static function contains(s: String): Predicate<String> {
    return function(value: String) {
      return value.contains(s);
    }
  }
}