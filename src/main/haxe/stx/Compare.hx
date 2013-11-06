package stx;

import stx.Method;
import Prelude;
import stx.plus.Equal;
import stx.plus.Order;

using stx.Strings;
using stx.Functions;
using stx.Iterables;
using stx.Maths;
using stx.Compose;

@doc("
  This is a good class to use in conjuncture with stx.UnitTest, stx.Assert and filters.

  ```
  import stx.Compare;.*;
  
  arr.filter(eq(3)) // produces predicate that returns true if input equals 3.
  ```
  nice.

  Unlikely to screw with other global namespace stuff, but keep an eye on it.
")
class Compare{
  @doc("Predicator for value v.")
  @:noUsing static public inline function compare<T>(v:T){
    return new Predicator(v);
  }
  @doc("Always returns true, no matter the input.")
  @:noUsing static public inline function always<T>():Predicate<T>{
    return function(value:T){return true;}
  }
  @doc("Always returns false, no matter the input.")
  @:noUsing static public inline function never<T>():Predicate<T>{
    return function(value:T){return false;}
  }
  @doc("Bools.isTrue")
  @:noUsing static public inline function ok():Predicate<Bool>{
    return function(value:Bool){return value;}
  }
  @doc("Bools.isFalse")
  @:noUsing static public inline function no():Predicate<Bool>{
    return function(value:Bool){return !value;}
  }
  @:noUsing static public inline function is<A>(cls:Class<A>):Predicate<A>{
    return Std.is.bind(_,cls);
  }
  @:noUsing static public inline function throws<A>(?type:Class<Dynamic>):Predicate<Void->Void>{
    return function(fn:Void->Void):Bool{
      var er = null;
      try{ 
        fn();
      }catch(e:Dynamic){ 
        er = e; 
      }
      return !(er == null) && (type != null ? Std.is(er,type) : true);
    }
  }
  @doc("null-check")
  @:noUsing static public inline function nl<T>():Predicate<T>{
    return function(value:T) {return value == null;}
  }
  @doc("not-null-check")
  @:noUsing static public inline function ntnl<T>():Predicate<T>{
    return function(value:T) {return value != null;}
  }
  @:noUsing static public inline function alike(e:EnumValue):Predicate<EnumValue>{
    return stx.Enums.alike.bind(e);
  }
  @:noUsing static public inline function matches(reg:EReg):Predicate<String>{
    return function(str:String){return reg.match(str);}
  }
  @doc("equals")
  @:noUsing static public inline function eq<T>(p:T):Predicate<T>{
    return Equal.getEqualFor(p).bind(p);
  }
  @doc("greater than")
  @:noUsing static public inline function gt<T>(p:T):Predicate<T>{
    return Order.getOrderFor(p).bind(p).then(Ints.eq.bind(1));
  }
  @doc("greater than or equal")
  @:noUsing static public inline function gteq<T>(p:T):Predicate<T>{
    return Order.getOrderFor(p).bind(p).then(Ints.gteq.bind(0));
  }
  @doc("less than")
  @:noUsing static public inline function lt<T>(p:T):Predicate<T>{
    return Order.getOrderFor(p).bind(p).then(Ints.eq.bind(-1));
  }
  @doc("less than or equal")
  @:noUsing static public inline function lteq<T>(p:T):Predicate<T>{
    return Order.getOrderFor(p).bind(p).then(Ints.lteq.bind(0));
  }
}
typedef PredicateType<T> = T -> Bool;
abstract Predicate<T>(PredicateType<T>) from PredicateType<T> to PredicateType<T>{
  public function new(v){
    this = v;
  }
  public function apply(v:T):Bool{
    return this(v);
  }
   @doc("Produces a predicate that succeeds if both succeed.")
  public inline function and(p: Predicate<T>): Predicate<T>{
    return PredicateLogic.and(this,p);
  }
  @doc("Produces a predicate that succeeds if all input predicates succeed.")
  public inline function andAll(ps: Iterable<Predicate<T>>): Predicate<T>{
    return PredicateLogic.andAll(this,ps);
  }
  @doc("Produces a predicate that succeeds if one or other predicates succeed.")
  public inline function or(p: Predicate<T>): Predicate<T>{
    return PredicateLogic.or(this,p);
  }
  @doc("Produces a predicate that succeeds if one or other, but not both predicates succeed.")
  public inline function xor(p: Predicate<T>): Predicate<T>{
    return PredicateLogic.xor(this,p);
  }
  @doc("Produces a predicate that succeeds if the input predicate fails.")
  public inline function not():Predicate<T>{
    return PredicateLogic.not(this);
  } 
  @doc("Produces a predicate that succeeds if any of the input predicates succeed.")
  public inline function orAny(ps: Iterable<Predicate<T>>): Predicate<T> {
    return PredicateLogic.orAny(this,ps);
  }
  @doc("Produces a Method from a Predicate.")
  public function toMethod():Method<T,Bool>{
    return new Method(this);
  }
}
@doc("Caches function lookup for value.")
class Predicator<T>{
  private var __eq__ : Reduce<T,Bool>;
  private var __od__ : Reduce<T,Int>;
  private var __dt__ : T;

  public function new(v:T){
    __dt__ = v;
  }
  public inline function eq():Predicate<T>{
    return _eq().bind(__dt__);
  }
  public inline function gt():Predicate<T>{
    return _od().bind(__dt__).then(Ints.eq.bind(1));
  }
  public inline function gteq():Predicate<T>{
    return _od().bind(__dt__).then(Ints.gteq.bind(0));
  }
  public inline function lt():Predicate<T>{
    return _od().bind(__dt__).then(Ints.eq.bind(-1));
  }
  public inline function lteq():Predicate<T>{
    return _od().bind(__dt__).then(Ints.lteq.bind(0));
  }
  private inline function _eq(){
    return this.__eq__ = __eq__ == null ? Equal.getEqualFor(__dt__) : __eq__;
  }
  private inline function _od(){
    return this.__od__ = __od__ == null ? Order.getOrderFor(__dt__) : __od__;
  }
}
class PredicateLogic{
  @doc("Produces a predicate that succeeds if both succeed.")
  static public function and<T>(p1: Predicate<T>, p2: Predicate<T>): Predicate<T> {
    return function(value) {
      return p1.apply(value) && p2.apply(value);
    }
  }
  @doc("Produces a predicate that succeeds if all input predicates succeed.")
  static public function andAll<T>(p1: Predicate<T>, ps: Iterable<Predicate<T>>): Predicate<T> {
    return function(value) {
      var result = p1.apply(value);
      
      for (p in ps) {
        if (!result) break;
        
        result = result && p.apply(value);
      }
      
      return result;
    }
  }
  @doc("Produces a predicate that succeeds if one or other predicates succeed.")
  static public function or<T>(p1: Predicate<T>, p2: Predicate<T>): Predicate<T> {
    return function(value:T) {
      return p1.apply(value) || p2.apply(value);
    }
  }
  @doc("Produces a predicate that succeeds if one or other , but not both predicates succeed.")
  static public function xor<T>(p1: Predicate<T>, p2: Predicate<T>): Predicate<T> {
    return function(value:T) {
      return or(p1,p2).apply(value) && (!and(p1,p2).apply(value));
    }
  }
  @doc("Produces a predicate that succeeds if the input predicate fails.")
  static public inline function not<T>(p1: Predicate<T>):Predicate<T>{
    return function(value:T){
      return !p1.apply(value);
    }
  }  
  @doc("Produces a predicate that succeeds if any of the input predicates succeeds.")
  static public function orAny<T>(p1: Predicate<T>, ps: Iterable<Predicate<T>>): Predicate<T> {
    return function(value) {
      var result = p1.apply(value);
      
      for (p in ps) {
        if (result) break;
        
        result = result || p.apply(value);
      }
      
      return result;
    }
  }
}