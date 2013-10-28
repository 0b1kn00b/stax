package stx;

import stx.Outcome;
import stx.Prelude;
import stx.Fail;
 
using stx.Eithers;

using stx.Functions;
using stx.Anys;

class CodeBlocks {
  static public function trampoline(func : CodeBlock, ?bounce : Int = 0) : CodeBlock {
    return function() : Void {
      if (bounce < 1) func();
      else stx.rct.Process.start(function() : Void func(), bounce);
    };
  }
  @doc("Compare function identity.")
  public static function equals(a:CodeBlock,b:CodeBlock){
    return Reflect.compareMethods(a,b);
  }
  @doc("Produces a function that takes a parameter, ignores it, and calls `f`.")
  public static function promote<A>(f: CodeBlock): A -> Void {
    return function(a: A): Void {
      f();
    }
  }
}	
class Functions0 {
  @doc("Applies a `Thunk` and returns an `Outcome`")
  public static function catching<A,B>(c:Thunk<A>):Thunk<Outcome<A>>{
    return function(){
        var o = null;
          try{
            o = Success(c());
          }catch(e:Fail){
            o = Failure(e);
          }catch(e:Dynamic){
            o = Failure(new Fail(NativeFail(Std.string(e))));
          }
        return o;
      }
  }
  @doc("Ignores error in `th` when called, instead returning a `null`")
  public static function suppress<A>(th:Thunk<A>):Thunk<Null<A>>{
    return function(){
      return try{
        th();
      }catch(d:Dynamic){
        null;
      }
    }
  }
  @doc("
    Returns a Thunk that applies a Thunk one time only and stores the result, 
    after which each successive call returns the stored value.
  ")
  @params("The Thunk to call once")
  @returns("A Thunk which will call the input Thunk once.")
  static public function memoize<T>(t: Thunk<T>): Thunk<T> {
    var evaled = false;
    var result = null;
    
    return function() {
      if (!evaled) { evaled = true; result = t(); }
      
      return result;
    }
  }
	@doc("Takes a function that returns a result, and produces one that ignores that result.")
	public static function enclose<R>(f:Thunk<R>):CodeBlock{
		return function():Void{
				f();
			}
	}
	@doc("Takes a function `f` and produces one that ignores any error the occurs whilst calling `f`.")
  public static function swallow(f: CodeBlock): CodeBlock {
    return function() {
      try {
        f();
      }
      catch (e: Dynamic) { }
    }
  }
	@doc("Produces a function that calls `f`, ignores its result, and returns the result produced by thunk.")
  public static function returning<R1, R2>(f: Void -> R1, thunk: Thunk<R2>): Void -> R2 {
    return function() {
      f();
      
      return thunk();
    }
  }
	@doc("Produces a function that takes a parameter. ignores it, and calls `f`, returning it's result.")
  public static function promote<A, Z>(f: Void -> Z): A -> Z {
    return function(a: A): Z {
      return f();
    }
  }
  @doc("
	  Produces a function that calls and stores the result of 'before', then `f`, then calls `after` with the result of 
	  `before` and finally returns the result of `f`.
	")
  public static function stage<Z, T>(f: Function0<Z>, before: Void -> T, after: T -> Void): Z {
    var state = before();
    
    var result = f();
    
    after(state);
    
    return result;   
  } 
  @doc("Compares function identity.")
  public static function equals<A>(a:Thunk<A>,b:Thunk<A>){     
    return Reflect.compareMethods(a,b);   
  } 
} 
class Functions1 {
  @doc("Applies a Thunk and returns Either an error or it's result")
  public static function catching<A,B>(fn:A->B):A->Outcome<B>{
    return function(a){
        var o = null;
          try{
            o = Success(fn(a));
          }catch(e:Fail){
            o = Failure(e);
          }catch(e:Dynamic){
            o = Failure(new Fail(NativeFail(Std.string(e))));
          }
        return o;
      }
  }
  @doc("
    Produces a function that produces a function for each
    parameter in the originating function. When these
    functions have been called, the result of the original function is produced.
  ")
  public static function curry<P1, R>(f: Function1<P1, R>) {     
    return function() { 
      return function(p1: P1) { 
        return f(p1);       
      }
    }   
  }   
  @doc("
    Produces a function that ignores any error the occurs whilst
    calling the input function.
  ")
  public static function swallow<A>(f: Function1<A, Void>): Function1<A, Void> {     
    return enclose(swallowWith(f, null));   
  }   
  @doc("
    Produces a function that ignores
    any error the occurs whilst calling the input function, and produces `d` if
    error occurs.     
  ")
  public static function swallowWith<P1, R>(f: Function1<P1, R>, d: R): Function1<P1, R> {     
    return
      function(a) {
        try {
          return f(a);       
        }catch (e:Dynamic) {
        }return d;     
      }   
  }   
  @doc("
    Produces a function that calls `f`, ignores its result, and returns the result
    produced by thunk.
  ")
  public static function returning<P1, R1, R2>(f: Function1<P1, R1>, thunk: Thunk<R2>) : Function1<P1, R2> {     
    return function(p1) {       
      f(p1);  
      return thunk();
    }
  }

	@doc("Produces a function that calls `f` with the given parameters `p1....pn`.")
  public static function lazy<P1, R>(f: Function1<P1, R>, p1: P1): Thunk<R> {
    var r = null;
    
    return function() {
      return if (r == null) { r = f(p1); r; } else r;
    }
  }
	@doc("Produces a function that calls `f`, ignoring the result.")
  public static function enclose<P1, R>(f: Function1<P1, R>): P1 -> Void {
    return function(p1) {
      f(p1);
    }
  }
  @doc("Compares function identity.")
  public static function equals<P1,R>(a:Function1<P1,R>,b:Function1<P1,R>){
    return Reflect.compareMethods(a,b);
  }
}
class Functions2 {  
  @doc("Places parameter 1 at the back.")
  static public function ccw<P1,P2,R>(f:Function2<P1,P2,R>):P2->P1->R{
    return 
      function(p2:P2,p1:P1){
        return f(p1,p2);
      }
  }
	@doc("Produces a function that ignores any error the occurs whilst calling the input function.")
  public static function swallow<P1, P2>(f: Function2<P1, P2, Void>): Function2<P1, P2, Void> {
    return enclose(swallowWith(f, null));
  }
	@doc("Produces a function that ignores any error the occurs whilst calling the input function, and produces `d` if error occurs.")
  public static function swallowWith<P1, P2, R>(f: Function2<P1, P2, R>, d: R): Function2<P1, P2, R> {
    return function(p1, p2) {
      try {
        return f(p1, p2);
      }
      catch (e: Dynamic) { }
      return d;
    }
  }
	@doc("Produces a function that calls `f`, ignores its result, and returns the result produced by thunk.")
  public static function returning<P1, P2, R1, R2>(f: Function2<P1, P2, R1>, thunk: Thunk<R2>): Function2<P1, P2, R2> {
    return function(p1, p2) {
      f(p1, p2);
      
      return thunk();
    }
  }
	@doc("Produces a function which takes the parameters of `f` in a flipped order.")
  public static function flip<P1, P2, R>(f: Function2<P1, P2, R>): Function2<P2, P1, R> {
    return function(p2, p1) {
      return f(p1, p2);
    }
  }
	@doc("
	  Produces a function that produces a function for each parameter in the originating function. When these
	  functions have been called, the result of the original function is returned.
	")
  public static function curry<P1, P2, R>(f: Function2<P1, P2, R>): Function1<P1, Function1<P2, R>> {
    return function(p1: P1) {
      return function(p2: P2) {
        return f(p1, p2);
      }
    }
  }
	@doc("
	  Takes a function with one parameter that returns a function of one parameter, and produces
	  a function that takes two parameters that calls the two functions sequentially,
	")
  public static function uncurry<P1, P2, R>(f: Function1<P1, Function1<P2, R>>): Function2<P1, P2, R> {
    return function(p1: P1, p2: P2) {
      return f(p1)(p2);
    }
  }
	@doc("Produdes a function that calls `f` with the given parameters `p1....pn`, and caches the result")
  public static function lazy<P1, P2, R>(f: Function2<P1, P2, R>, p1: P1, p2: P2): Thunk<R> {
    var r = null;
    
    return function() {
      return r == null ? r = f(p1, p2) : r;
    }
  }
  @doc("As with lazy, but calls the wrapped function every time it is called.")
  static public function defer<P1, P2, R>(f: Function2<P1, P2, R>, p1 : P1, p2 : P2):Thunk<R>{
    return function(){
      return f(p1,p2);
    }
  }
	@doc("Produces a function that calls `f`, ignoring the result.")
  public static function enclose<P1, P2, R>(f: Function2<P1, P2, R>): P1 -> P2 -> Void {
    return function(p1, p2) {
      f(p1, p2);
    }
  }
  @doc("Compares function identity.")
  public static function equals<P1,P2,R>(a:Function2<P1,P2,R>,b:Function2<P1,P2,R>){
    return Reflect.compareMethods(a,b);
  }
}
class Functions3 {
  @doc("Places first parameter at the back.")
  static public function ccw<P1,P2,P3,R>(f:Function3<P1,P2,P3,R>):P2->P3->P1->R{
    return function(p2:P2,p3:P3,p1:P1){
      return f(p1,p2,p3);
    }
  }
	@doc("Produces a function that ignores any error the occurs whilst calling the input function.")
  public static function swallow<A, B, C>(f: Function3<A, B, C, Void>): Function3<A, B, C, Void> {
    return enclose(swallowWith(f, null));
  }
	@doc("Produces a function that ignores any error the occurs whilst calling the input function, and produces `d` if error occurs.")
  public static function swallowWith<A, B, C, R>(f: Function3<A, B, C, R>, d: R): Function3<A, B, C, R> {
    return function(a, b, c) {
      try {
        return f(a, b, c);
      }
      catch (e: Dynamic) { }
      return d;
    }
  }
	@doc("Produces a function that calls `f`, ignores its result, and returns the result produced by thunk.")
  public static function returning<P1, P2, P3, R1, R2>(f: Function3<P1, P2, P3, R1>, thunk: Thunk<R2>): Function3<P1, P2, P3, R2> {
    return function(p1, p2, p3) {
      f(p1, p2, p3);
      
      return thunk();
    }
  }
	@doc("
	  Produces a function that produces a function for each parameter in the originating function. When these
	  functions have been called, the result of the original function is produced.
	")
  public static function curry<P1, P2, P3, R>(f: Function3<P1, P2, P3, R>): Function1<P1, Function1<P2, Function1<P3, R>>> {
    return function(p1: P1) {
      return function(p2: P2) {
        return function(p3: P3) {
          return f(p1, p2, p3);
        }
      }
    }
  }
	@doc("
	  Takes a function with one parameter that returns a function of one parameter, and produces
	  a function that takes two parameters that calls the two functions sequentially,
	")
  public static function uncurry<P1, P2, P3, R>(f: Function1<P1, Function1<P2, Function1<P3, R>>>): Function3<P1, P2, P3, R> {
    return function(p1: P1, p2: P2, p3: P3) {
      return f(p1)(p2)(p3);
    }
  }
  public static function uncurry2<P1, P2, P3, R>(f: Function1<P1, Function1<P2, Function1<P3, R>>>): Function2<P1, P2, P3 -> R> {
    return function(p1: P1, p2: P2) {
      return function(p3: P3){
        return f(p1)(p2)(p3);
      }
    }
  }
	@doc("Produdes a function that calls `f` with the given parameters `p1....pn`.")
  public static function lazy<P1, P2, P3, R>(f: Function3<P1, P2, P3, R>, p1: P1, p2: P2, p3: P3): Thunk<R> {
    var r = null;
    
    return function() {
      return if (r == null) { r = f(p1, p2, p3); r; } else r;
    }
  }
	@doc("
	  Produces a function that calls `f`, ignoring the result.
   ")
  public static function enclose<P1, P2, P3, R>(f: Function3<P1, P2, P3, R>): P1 -> P2 -> P3 -> Void {
    return function(p1, p2, p3) {
      f(p1, p2, p3);
    }
  }
  @doc("Compares function identity.")
  public static function equals<P1,P2,P3,R>(a:Function3<P1,P2,P3,R>,b:Function3<P1,P2,P3,R>){
    return Reflect.compareMethods(a,b);
  }
}
class Functions4 {  
  @doc("Pushes first parameter to the last")
  static public function ccw<P1,P2,P3,P4,R>(f:Function4<P1,P2,P3,P4,R>):P2->P3->P4->P1->R{
    return function(p2,p3,p4,p1){
      return f(p1,p2,p3,p4);
    }
  }
	@doc("Produces a function that ignores any error the occurs whilst calling the input function.")
  public static function swallow<A, B, C, D>(f: Function4<A, B, C, D, Void>): Function4<A, B, C, D, Void> {
    return enclose(swallowWith(f, null));
  }
	@doc("Produces a function that ignores any error the occurs whilst calling the input function, and produces `d` if error occurs.")
  public static function swallowWith<A, B, C, D, R>(f: Function4<A, B, C, D, R>, def: R): Function4<A, B, C, D, R> {
    return function(a, b, c, d) {
      try {
        return f(a, b, c, d);
      }
      catch (e: Dynamic) { }
      return def;
    }
  }
	@doc("Produces a function that calls `f`, ignores its result, and returns the result produced by thunk.")
  public static function returning<P1, P2, P3, P4, R1, R2>(f: Function4<P1, P2, P3, P4, R1>, thunk: Thunk<R2>): Function4<P1, P2, P3, P4, R2> {
    return function(p1, p2, p3, p4) {
      f(p1, p2, p3, p4);
      
      return thunk();
    }
  }
	@doc("
	  Produces a function that produces a function for each parameter in the originating function. When these
	  functions have been called, the result of the original function is produced.
	")
  public static function curry<P1, P2, P3, P4, R>(f: Function4<P1, P2, P3, P4, R>): Function1<P1, Function1<P2, Function1<P3, Function1<P4, R>>>> {
    return function(p1: P1) {
      return function(p2: P2) {
        return function(p3: P3) {
          return function(p4: P4) {
            return f(p1, p2, p3, p4);
          }
        }
      }
    }
  }
	@doc("
	  Takes a function with one parameter that returns a function of one parameter, and produces
	  a function that takes two parameters that calls the two functions sequentially,
	")
  public static function uncurry<P1, P2, P3, P4, R>(f: Function1<P1, Function1<P2, Function1<P3, Function1<P4, R>>>>): Function4<P1, P2, P3, P4, R> {
    return function(p1: P1, p2: P2, p3: P3, p4: P4) {
      return f(p1)(p2)(p3)(p4);
    }
  }
	@doc("Produdes a function that calls `f` with the given parameters `p1....pn`.")
  public static function lazy<P1, P2, P3, P4, R>(f: Function4<P1, P2, P3, P4, R>, p1: P1, p2: P2, p3: P3, p4: P4): Thunk<R> {
    var r = null;
    
    return function() {
      return if (r == null) { r = f(p1, p2, p3, p4); r; } else r;
    }
  }
	@doc("Produces a function that calls `f`, ignoring the result.")
  public static function enclose<P1, P2, P3, P4, R>(f: Function4<P1, P2, P3, P4, R>): P1 -> P2 -> P3 -> P4 -> Void {
    return function(p1, p2, p3, p4) {
      f(p1, p2, p3, p4);
    }
  }
  @doc("Compares identity of methods.")
  public static function equals<P1,P2,P3,P4,R>(a:Function4<P1,P2,P3,P4,R>,b:Function4<P1,P2,P3,P4,R>){
    return Reflect.compareMethods(a,b);
  }
}
class Functions5 {  
  static public function ccw<P1,P2,P3,P4,P5,R>(f:Function5<P1,P2,P3,P4,P5,R>):P2->P3->P4->P5->P1->R{
    return function(p2:P2,p3:P3,p4:P4,p5:P5,p1:P1){
      return f(p1,p2,p3,p4,p5);
    }
  }
	@doc("Produces a function that ignores any error the occurs whilst calling the input function.")
  public static function swallow<A, B, C, D, E>(f: Function5<A, B, C, D, E, Void>): Function5<A, B, C, D, E, Void> {
    return enclose(swallowWith(f, null));
  }
	@doc("Produces a function that ignores any error the occurs whilst calling the input function, and produces `d` if error occurs.")
  public static function swallowWith<A, B, C, D, E, R>(f: Function5<A, B, C, D, E, R>, def: R): Function5<A, B, C, D, E, R> {
    return function(a, b, c, d, e) {
      try {
        return f(a, b, c, d, e);
      }
      catch (e: Dynamic) { }
      return def;
    }
  }
	@doc("Produces a function that calls `f`, ignores its result, and returns the result produced by thunk.")
  public static function returning<P1, P2, P3, P4, P5, R1, R2>(f: Function5<P1, P2, P3, P4, P5, R1>, thunk: Thunk<R2>): Function5<P1, P2, P3, P4, P5, R2> {
    return function(p1, p2, p3, p4, p5) {
      f(p1, p2, p3, p4, p5);
      
      return thunk();
    }
  }
	@doc("
	  Produces a function that produces a function for each parameter in the originating function. When these
	  functions have been called, the result of the original function is produced.
	")
  public static function curry<P1, P2, P3, P4, P5, R>(f: Function5<P1, P2, P3, P4, P5, R>): Function1<P1, Function1<P2, Function1<P3, Function1<P4, Function1<P5, R>>>>> {
    return function(p1: P1) {
      return function(p2: P2) {
        return function(p3: P3) {
          return function(p4: P4) {
            return function(p5: P5) {
              return f(p1, p2, p3, p4, p5);
            }
          }
        }
      }
    }
  }
	@doc("
	  Takes a function with one parameter that returns a function of one parameter, and produces
	  a function that takes two parameters that calls the two functions sequentially,
	")
  public static function uncurry<P1, P2, P3, P4, P5, R>(f: Function1<P1, Function1<P2, Function1<P3, Function1<P4, Function1<P5, R>>>>>): Function5<P1, P2, P3, P4, P5, R> {
    return function(p1: P1, p2: P2, p3: P3, p4: P4, p5: P5) {
      return f(p1)(p2)(p3)(p4)(p5);
    }
  }
	@doc("Produdes a function that calls `f` with the given parameters `p1....pn`.")
  public static function lazy<P1, P2, P3, P4, P5, R>(f: Function5<P1, P2, P3, P4, P5, R>, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5): Thunk<R> {
    var r = null;
    
    return function() {
      return if (r == null) { r = f(p1, p2, p3, p4, p5); r; } else r;
    }
  }
	@doc("Produces a function that calls `f`, ignoring the result.")
  public static function enclose<P1, P2, P3, P4, P5, R>(f: Function5<P1, P2, P3, P4, P5, R>): P1 -> P2 -> P3 -> P4 -> P5 -> Void {
    return function(p1, p2, p3, p4, p5) {
      f(p1, p2, p3, p4, p5);
    }
  }
  @doc("Method equals.")
  public static function equals<P1,P2,P3,P4,P5,R>(a:Function5<P1,P2,P3,P4,P5,R>,b:Function5<P1,P2,P3,P4,P5,R>){
    return Reflect.compareMethods(a,b);
  }
}
class Functions6{
  public static function curry<P1, P2, P3, P4, P5, P6, R>(f: Function6<P1, P2, P3, P4, P5, P6, R>)
  : Function1<P1, Function1<P2, Function1<P3, Function1<P4, Function1<P5, Function1<P6, R> >>>>> {
    return function(p1: P1) {
      return function(p2: P2) {
        return function(p3: P3) {
          return function(p4: P4) {
            return function(p5: P5) {
              return function(p6: P6){
                return f(p1, p2, p3, p4, p5, p6);
              }
            }
          }
        }
      }
    }
  }
}