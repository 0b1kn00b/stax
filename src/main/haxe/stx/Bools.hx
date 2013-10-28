package stx;

import stx.Prelude;

class Bools {
  @doc("Returns the Int representation of a Bool.")
  static public function toInt(v: Bool): Float { return if (v) 1 else 0; }
  
  @doc("Produces the result of `f` if `v` is true.")
  static public function ifTrue<T>(v: Bool, f: Thunk<T>): Option<T> {
    return if (v) Some(f()) else None;
  }
  @doc("Produces the result of `f` if `v` is false.")  
  static public function ifFalse<T>(v: Bool, f: Thunk<T>): Option<T> {
    return if (!v) Some(f()) else None;
  }
  @doc("Produces the result of `f1` if `v` is true, `f2` otherwise.")
  static public function ifElse<T>(v: Bool, f1: Thunk<T>, f2: Thunk<T>): T {
    return if (v) f1() else f2();
  }  
  @doc("Compares Ints, returning -1 if (false,true), 1 if (true,false), 0 otherwise.")
  static public function compare(v1 : Bool, v2 : Bool) : Int {
    return if (!v1 && v2) -1 else if (v1 && !v2) 1 else 0;   
  }
  @doc("Returns `true` if `v1` and `v2` are the same, `false` otherwise.")
  static public function equals(v1 : Bool, v2 : Bool) : Bool {
    return v1 == v2;   
  }
  @doc("Shortcut for `equals`")
  static public inline function eq(v1:Bool, v2:Bool) return v1 == v2;  
  @doc("Returns `true` if both `v1` and `v2` are `true`, `false` otherwise.")
  static public inline function and(v1:Bool, v2:Bool) return v1 && v2;
  @doc("Returns `true` if `v1` and `v2` are different, `false` otherwise.")
  static public inline function nand(v1:Bool, v2:Bool){
    if( v1 ) return !v2;
    else return v2;
  }
  @doc("Returns `true` if `v1` or `v2` are `true`, `false` otherwise.")
  static public inline function or(v1:Bool, v2:Bool) {
    return v1 || v2;
  }
  @doc("Returns `true` if `v` is `true`, `false` otherwise.")
  static public inline function not(v:Bool) {
    return !v;
  }
}