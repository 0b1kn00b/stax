package stx;

import stx.Prelude;

class Bools 
{
  static public function toInt(v: Bool): Float { return if (v) 1 else 0; }
  
  /**
    Produces the result of 'f' if 'v' is true.
   */
  static public function ifTrue<T>(v: Bool, f: Thunk<T>): Option<T> {
    return if (v) Some(f()) else None;
  }
  /**
    Produces the result of 'f' if 'v' is false.
   */  
  static public function ifFalse<T>(v: Bool, f: Thunk<T>): Option<T> {
    return if (!v) Some(f()) else None;
  }
  /**
    Produces the result of 'f1' if 'v' is true, 'f2' otherwise.
   */
  static public function ifElse<T>(v: Bool, f1: Thunk<T>, f2: Thunk<T>): T {
    return if (v) f1() else f2();
  }  
  /**
    Compares ints, returning -1 if (false,true), 1 if (true,false), 0 otherwise
  */
  static public function compare(v1 : Bool, v2 : Bool) : Int 
  {
    return if (!v1 && v2) -1 else if (v1 && !v2) 1 else 0;   
  }
  static public function equals(v1 : Bool, v2 : Bool) : Bool {
    return v1 == v2;   
  }
  public function function_name(arguments) {
    
  }
  public static inline function eq(v1:Bool, v2:Bool) return v1 == v2;  
  public static inline function and(v1:Bool, v2:Bool) return v1 && v2;
  public static inline function or(v1:Bool, v2:Bool) return v1 || v2;
  public static inline function not(v:Bool) return !v;
}