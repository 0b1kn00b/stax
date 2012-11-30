package stx;

using stx.ArrowFn;
using stx.Tuples;
using stx.Prelude;
using stx.Functions;

class ArrowFn0{
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
class ArrowFn{
  /**
    Returns a function that applies fn1 then fn2 on the input
  */
  static public function then<A,B,C>(fn1:A->B,fn2:B->C):A->C{
    return fn1.andThen(fn2);
  }
  /**
    Returns a function that applies fn1 to the left hand side of a Tuple
  */
  static public function first<A,B,C,D>(fn1:A->C):Tuple2<A,B>->Tuple2<C,B>{
    return 
      function(t:Tuple2<A,B>){
        return Tuples.t2(fn1(t._1),t._2);
      }
  }
  /**
    Returns a function that applies fn1 to the right hand side of a Tuple
  */
  static public function second<A,B,C,D>(fn1:B->D):Tuple2<A,B>->Tuple2<A,D>{
    return 
      function(t:Tuple2<A,B>){
        return Tuples.t2(t._1,fn1(t._2));
      } 
  }
  static public function pair<A,B,C,D>(fn1:A->C,fn2:B->D):Tuple2<A,B>->Tuple2<C,D>{
    return 
      function(t){
        return Tuples.t2(fn1(t._1),fn2(t._2));
      }
  }
  /**
    Returns a function that applies fn1 to the left hand side of a Tuple and fn2 to the right.
  */
  static public function compose<A,B,C,D>(fn1:A->B,fn2:C->D):Tuple2<A,C>->Tuple2<B,D>{
    return 
      function(t:Tuple2<A,C>):Tuple2<B,D>{
        return Tuples.t2(fn1(t._1),fn2(t._2));
      }
  }
  /**
    Returns a function that applies a function on the lhs of a tuple to the value on the rhs.
  */
  static public function applyFn<A,I,O>(fn:A->Tuple2<I->O,I>):A->O{
    return 
      function(v:A):O{
        var t = fn(v);
        return t._1(t._2);
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
  @:noUsing
  static public function pure<A,B>():A->B{
    return cast Prelude.pure();
  }
  /**
    Returns a function that produces a `Tuple2` from a value.
  */
  static public function fan<I,O>(a:I->O):I->Tuple2<O,O>{
    return 
      a.then(
        function(x){
          return Tuples.t2(x,x);
        }
      );
  }
  static public function constant<A,B>(v:B):A->B{
    return function(x:A){ return v; }
  }
  static public function split<A,B,C>(split_:A->B,_split:A->C):A->Pair<B,C>{ 
    return 
      function(x){
        return Tuples.t2( split_(x), _split(x) );
      }
  }
  static public function bind<A,B,C>(bindl:A->C,bindr:Pair<A,C>->B):A->B{
    return pure().split(bindl).then( bindr );
  }
}