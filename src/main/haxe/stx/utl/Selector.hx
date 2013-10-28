package stx.utl;

import stx.plus.Equal;
import stx.Compare;

using stx.Prelude;
using stx.Arrays;
using stx.Tuples;
using stx.Option;
using stx.Compose;

typedef SelectorType<I> = Tuple2<I->I->Bool,I>;

@doc("
  Represents an equality function and it's first parameter used as a predicate.
")
abstract Selector<I>(SelectorType<I>) from SelectorType<I> to SelectorType<I>{
  public function pure(v){
    return new Selector(v);
  }
  public function new(v){
    this = v;
  }
  @:from public static inline function fromString(str:String):Selector<String>{
    return tuple2(stx.Strings.equals,str);
  }
  @:from public static inline function fromFunction<T>(fn:T->Bool):Selector<T>{
    return tuple2(
      function(l,r){
        return fn(r);
      },
      null
    );
  }
  @:from static public inline function fromPredicate<T>(prd:Predicate<T>):Selector<T>{
    return fromFunction(prd);
  }
  @:from public static inline function fromT<T>(d:T):Selector<T>{
    return new Selector(tuple2(stx.plus.Equal.getEqualFor(d),d));
  }
  public function value():I{
    return this.snd();
  }
  public function predicate2():I->I->Bool{
    return this.fst();
  }
  public function apply(v:I):Bool{
    return predicate2()(value(),v);
  }
  public function valueEqualsWith(slct:Selector<I>,equal:I->I->Bool):Bool{
    return equal(value(),slct.value());
  }
}