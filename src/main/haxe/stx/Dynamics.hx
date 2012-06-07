package stx;

/**
 * ...
 * @author 0b1kn00b
 */
import Prelude;

class Dynamics {
	/**
	 * Takes a value, applies a Function1 to the value and returns the original value.
	 * @param 		a			Any value.
	 * @param 		f			Modifier function.
	 * @return 		a			The input value after f(a).
	 */
  public static function withEffect<T>(t: T, f: Function1<T, Void>): T {
    f(t);
    
    return t;
  }
	/**
	 * Takes a value, applies a Function1 to the value and returns the original value.
	 * @param 		a			Any value.
	 * @param 		f			Modifier function.
	 * @return 		a			The input value after f(a).
	 */
  public static function withEffectP<A, B>(a: A, f: Function1<A, B>): A {
    f(a);
    
    return a;
  }
	/**
	 * Applies Function1 f to value a and returns the result.
	 * @param			a			Any value.
	 * @param    	f 		Modifier function.
	 * @usage a.into( function(x) return ... )
	 */
  public static function into<A, B>(a: A, f: A -> B): B {
    return f(a);
  }
	
	/**
	 * Returns a Thunk that applies a Thunk one time only and stores the result, after which each successive call returns the stored value.
	 * @param  	t		The Thunk to call once
	 * @return 			A Thunk which will call the input Thunk once.
	 */
  public static function memoize<T>(t: Thunk<T>): Thunk<T> {
    var evaled = false;
    var result = null;
    
    return function() {
      if (!evaled) { evaled = true; result = t(); }
      
      return result;
    }
  }
	/**
	 * Returns a Thunk that will always return the input value t.
	 * @param 		t		Any value
	 * @return 				A function that will return the input value t.
	 */
  public static function toThunk<T>(t: T): Thunk<T> {
    return function() {
      return t;
    }
  }  
	
	/**
	 * Produces a Function1 that will return the input value t, regardless of the Function1's input.
	 * @param			t		Any value
	 * @return 				A function taking any value and returning the value of input parameter t.
	 */
  public static function toConstantFunction<S, T>(t: T): Function1<S, T> {
    return function(s: S) {
      return t;
    }
  }
  /**
  * Applies a function 'f' to a valuse of any Type.
  */
  public static function apply<A,B>(v:A,fn:A->Void):Void{
  	fn(v);
  }
}