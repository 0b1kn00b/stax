package stx;

using stx.Tuples;
using stx.Future;

enum ReturnType<T>{
  Now(now:T);
  Later(later:Future<T>);
}
abstract Return<T>(ReturnType<T>) from ReturnType<T> to ReturnType<T>{
  public function new(v){
    this = v;
  }
  @:from public static inline function fromFuture<T>(v:Future<T>):Return<T>{
    return Later(v);
  }
  @:from public static inline function fromImmediate<T>(v:T):Return<T>{
    return Now(v);
  }
}
class Returns{
  static public function map<S,T>(rt:Return<S>,fn:S->T):Return<T>{
    return switch (rt) {
      case Now(v)       : Now(fn(v));
      case Later(v)     : Later(v.map(fn));
    }
  }
  static public function flatMap<A,B>(rt:Return<A>,fn:A->Return<B>):Return<B>{
    return switch (rt) {
      case Now(v)       : fn(v);
      case Later(v)     :
        Later(v.map(fn).flatMap(
          function(x){
            return switch (x) {
              case Now(v)   : Future.pure(v);
              case Later(v) : v;
            }
          }
        ));
    }
  }
  static public function zipWith<A,B,C>(rt0:Return<A>,rt1:Return<B>,fn:A->B->C):Return<C>{
    return switch ([rt0,rt1]) {
      case [Now(a),Now(b)]      : Now(fn(a,b));
      case [Now(a),Later(b)]    : Later(b.map(tuple2.bind(a)).map(fn.tupled()));
      case [Later(a),Now(b)]    : Later(a.map(tuple2.bind(_,b)).map(fn.tupled()));
      case [Later(a),Later(b)]  : Later(a.zipWith(b,fn));
    }
  }
  static public function zip<A,B>(rt0:Return<A>,rt1:Return<B>):Return<Tuple2<A,B>>{
    return zipWith(rt0,rt1,tuple2);
  }
}