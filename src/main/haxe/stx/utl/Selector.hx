package stx.utl;

import stx.Equal;
import stx.Compare;

using Prelude;
using stx.Arrays;
using stx.Tuples;
using stx.Option;
using stx.Compose;

typedef SelectorType<I> = Tuple2<I->I->Bool,I>;

@:todo('#0b1kn00b: more thorough tests.')
@doc("
  Represents an equality function and it's first parameter used as a predicate.
")
abstract Selector<I>(SelectorType<I>) from SelectorType<I> to SelectorType<I>{
  @:noUsing static public function create<I>(fn:I->I->Bool,v:I):Selector<I>{
    return tuple2(fn,v);
  }
  @:noUsing static public function unit<I>(){
    return pure(tuple2(function(i,i) return true,null));
  }
  @:noUsing static public function pure(v){
    return new Selector(v);
  }
  public function new(v:SelectorType<I>){
    this = v;
  }
  @:from public static inline function fromString(str:String):Selector<String>{
    return tuple2(stx.Strings.equals,str);
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