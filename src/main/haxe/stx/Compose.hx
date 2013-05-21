package stx;

import stx.Tuples.*;

using stx.Compose;
using stx.Tuples;
using stx.Prelude;
using stx.Functions;
using stx.Eithers;

class ComposeDo{
  /**
    Produces a function that calls 'f1' and 'f2' in left to right order.
    @param  f1
    @param  f2
    @return The composite function.
  */
  public static function then(f1: Void -> Void, f2: Void -> Void): Void -> Void {
    return function() {
      f1();
      f2();
    }
  }
}
class ComposeDo1{
  /**     
    Produces a function that
    calls 'f1' and 'f2' in left to right order with the same input, and returns no
    result.     
    @param  f1     
    @param  f2     
    @return The composite function.
  */
  public static function then<P1>(f1: P1 -> Void, f2: P1 -> Void): P1 -> Void {     
    return function(p1) {       f1(p1);       f2(p1);     }   
  }   
}
class ComposeDo2{
  /**
    Produces a function that calls 'f1' and 'f2' in left to right order with the same input, and returns no result.
    @param  f1
    @param  f2
    @return The composite function.
  */
  public static function then<P1, P2>(f1: P1 -> P2 -> Void, f2: P1 -> P2 -> Void): P1 -> P2 -> Void {
    return function(p1, p2) {
      f1(p1, p2);
      f2(p1, p2);
    }
  }
}
class ComposeDo3{
  /**
    Produces a function that calls 'f1' and 'f2' in left to right order with the same input, and returns no result.
    @param  f1
    @param  f2
    @return The composite function.
  */
  public static function then<P1, P2, P3>(f1: P1 -> P2 -> P3 -> Void, f2: P1 -> P2 -> P3 -> Void): P1 -> P2 -> P3 -> Void {
    return function(p1, p2, p3) {
      f1(p1, p2, p3);
      f2(p1, p2, p3);
    }
  }
}
class ComposeDo4{
  /**
    Produces a function that calls 'f1' and 'f2' in left to right order with the same input, and returns no result.
    @param  f1
    @param  f2
    @return The composite function.
  */
  public static function then<P1, P2, P3, P4>(f1: P1 -> P2 -> P3 -> P4 -> Void, f2: P1 -> P2 -> P3 -> P4 -> Void): P1 -> P2 -> P3 -> P4 -> Void {
    return function(p1, p2, p3, p4) {
      f1(p1, p2, p3, p4);
      f2(p1, p2, p3, p4);
    }
  }
}
class ComposeDo5{
  /**
    Produces a function that calls 'f1' and 'f2' in left to right order with the same input, and returns no result.
    @param  f1
    @param  f2
    @return The composite function.
  */
  public static function then<P1, P2, P3, P4, P5>(f1: P1 -> P2 -> P3 -> P4 -> P5 -> Void, f2: P1 -> P2 -> P3 -> P4 -> P5 -> Void): P1 -> P2 -> P3 -> P4 -> P5 -> Void {
    return function(p1, p2, p3, p4, p5) {
      f1(p1, p2, p3, p4, p5);
      f2(p1, p2, p3, p4, p5);
    }
  }
}
class Compose0{
  static public function then<A, B>(fn0:Thunk<A>,fn1:A->B):Thunk<B>{
    return 
      function():B{
        return fn1(fn0());
      }
  }
}
/**
  Arrow class for Functions.
*/
class Compose{
  
  static public function fstOf<A,B,C,D>(a:Tuple2<A,B>->Tuple2<C,D>):Tuple2<A,B>->C{
    return a.then( T2s.fst );
  }
  static public function sndOf<A,B,C,D>(a:Tuple2<A,B>->Tuple2<C,D>):Tuple2<A,B>->D{
    return a.then( T2s.snd );
  }
  /**
    Returns a function that applies fn1 then fn2 on the input
  */
  static public function then<A,B,C>(fn1:A->B,fn2:B->C):A->C{
    return 
      function(a:A):C{
        return fn2(fn1(a));
      }
  }
  /**
    Returns a function that applies fn1 to the left hand side of a Tuple
  */
  static public function first<A,B,C,D>(fn1:A->C):Tuple2<A,B>->Tuple2<C,B>{
    return 
      function(t:Tuple2<A,B>){
        return tuple2(fn1(t.fst()),t.snd());
      }
  }
  /**
    Returns a function that applies fn1 to the right hand side of a Tuple
  */
  static public function second<A,B,C,D>(fn1:B->D):Tuple2<A,B>->Tuple2<A,D>{
    return 
      function(t:Tuple2<A,B>){
        return tuple2(t.fst(),fn1(t.snd()));
      } 
  }
  static public function pair<A,B,C,D>(fn1:A->C,fn2:B->D):Tuple2<A,B>->Tuple2<C,D>{
    return 
      function(t){
        return tuple2(fn1(t.fst()),fn2(t.snd()));
      }
  }
  /**
    Returns a function that applies a function on the lhs of a tuple to the value on the rhs.
  */
  static public function apply<A,I,O>(fn:A->Tuple2<I->O,I>):A->O{
    return 
      function(v:A):O{
        var t = fn(v);
        return t.fst()(t.snd());
      }
  }
  /**
    Returns a function that applies a function to the Left value of an Either.
  */
  static public function left<A,B,C>(fn:A->C):Either<A,B>->Either<C,B>{
    return 
      function(e:Either<A,B>):Either<C,B>{
        return 
          switch (e) {
            case Left(v)  : Left(fn(v));
            case Right(v) : Right(v);
          }
      }
  }
  /**
    Returns a function that applies a function to the Right value of an Either.
  */
  static public function right<A,B,D>(fn:B->D):Either<A,B>->Either<A,D>{
    return 
      function(e:Either<A,B>):Either<A,D>{
        return 
          switch (e) {
            case Left(v)  : Left(v);
            case Right(v) : Right(fn(v));
          }
      }
  }
  static public function fromR<A,B,C>(fn:B->Either<A,C>):Either<A,B>->Either<A,C>{
    return function(e:Either<A,B>){
      return switch (e){
        case    Left(l)      : Left(l);
        case    Right(r)     : fn(r);
      }
    }
  }
  /**
    Pure function.
    [[1,2],[3,4]].flatMap( Compose.pure() );//[1,2,3,4]
  */
  @:noUsing
  static public function unit<A,B>():A->A{
    return cast function(x) return x;
  }
  /**
    Returns a function that produces a `Tuple2` from a value.
  */
  static public function fan<I,O>(a:I->O):I->Tuple2<O,O>{
    return 
      a.then(
        function(x){
          return tuple2(x,x);
        }
      );
  }
  /**
    Returns a function that produces `v`.
  */
  static public function pure<A,B>(v:B):A->B{
    return function(x:A){ return v; }
  }
  static public function split<A,B,C>(split_:A->B,_split:A->C):A->Tuple2<B,C>{ 
    return function(x){
        return tuple2( split_(x), _split(x) );
      }
  }
  static public function binds<A,B,C>(bindl:A->C,bindr:Tuple2<A,C>->B):A->B{
    return unit().split(bindl).then( bindr );
  }
  static public function pinch<A,B,C>(fn0:Tuple2<A,A>->Tuple2<B,C>):A->Tuple2<B,C>{
    return 
      function(x:A){
        return fn0(tuple2(x,x));
      }
  }
  static public function both<A,B>(fn:A->B):Pair<A>->Pair<B>{
    return 
      function(t){
        return tuple2(fn(t.fst()),fn(t.snd()));
      }
  }
  /**
    Returns a function that calls 'f1' with the output of 'f2'.
    @param f1
    @param f2
  */
  public static function compose<U, V, W>(f1: Function1<V, W>, f2: Function1<U, V>): Function1<U, W> {
    return function(u: U): W {
      return f1(f2(u));
    }
  }
  static public function option<A,B>(fn:A->B):Option<A>->Option<B>{
    return Options.map.bind(_,fn);
  }
  static public function fromMbe<A,B>(fn:A->Option<B>):Option<A>->Option<B>{
    return Options.map.bind(_,fn).then(Options.flatten);
  }
}
class Compose2{
  /**
    Returns a function that calls 'f2' with the output of 'f1'.
    @param f1
    @param f2
  */
  public static function then<U, V, W, X>(f1: Function2<U, V, W>, f2: Function1<W, X>): Function2<U, V, X> {
    return 
      function(u:U,v:V):X{
        return f2(f1(u,v));
      }
  }
}