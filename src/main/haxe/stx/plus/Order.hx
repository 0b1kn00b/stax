package stx.plus;

import Stax.*;
import Type;

using Std;

import stx.type.*;
import stx.Maths;
import stx.Tuples;

using stx.Tuples;
using Prelude;
using stx.plus.Order;

class Order {

	static function __order__<T>(impl: Ord<T>): Ord<T> {
    return function(a, b) {
    return if(a == b || (a == null && b == null)) 0;
      else if(a == null) -1;
      else if(b == null) 1;
      else impl(a, b);
    };
  }
  @:noUsing
  static public function nil<A>(a:A,b:A){
    return 
      __order__(function(a:A, b:A) { return except()(IllegalOperationError("at least one of the arguments should be null")); })(a,b);
  } 
  /** Returns a OrderFunction (T -> T -> Int). It works for any type expect TFunction.
   *  Custom Classes must provide a compare(other : T): Int method or an exception will be thrown.
   */
  static public function getOrderFor<T>(t : T): Ord<T> {
    return getOrderForType(Type.typeof(t));
  }
  static public function getOrderForType<T>(v: ValueType): Ord<T> {
    return switch(v) {
      case TBool    : __order__(cast Bools.compare);
      case TInt     : __order__(cast Ints.compare);
      case TFloat   : __order__(cast Floats.compare);
      case TUnknown : function(a : T, b : T) return (a == b) ? 0 : ((cast a) > (cast b) ? 1 : -1);
      case TObject:
        __order__(function(a, b) {
          for(key in Reflect.fields(a)) {
            var va = Reflect.field(a, key);
  					var vb = Reflect.field(b, key);
            var v = getOrderFor(va)(va, vb);
            if(0 != v)
              return v;
          }
          return 0;
        });
      case TClass(c) if (c == String): __order__(cast Strings.compare);
      case TClass(c) if (c == Date)   : __order__(cast Dates.compare);
      case TClass(c) if (c == Array)  : __order__(cast ArrayOrder.compare);
      case TClass(c):
        if(Type.getInstanceFields(c).remove("compare")) {
          __order__(function(a, b) return (cast a).compare(b));
   		  } else {
          except()(IllegalOperationError("class ${vtype(c).name()} is not comparable."));
        }
      case TEnum(_)   : __order__(cast EnumOrder.sort);
      case TNull      :  nil;
      case TFunction  : except()(IllegalOperationError("unable to compare on a function"));
    }
  }
}
class EnumOrder{
  static public function sort(a : EnumValue, b: EnumValue) {
    var v = Type.enumIndex(a) - Type.enumIndex(b);
    if(0 != v)
      return v;
    var pa = Type.enumParameters(a);
    var pb = Type.enumParameters(b);
    for(i in 0...pa.length) {
      var v = Order.getOrderFor(pa[i])(pa[i], pb[i]);
      if(v != 0)
        return v;
    }
    return 0;
  }
}
class ArrayOrder {
	static public function sort<T>(v : Array<T>): Array<T> {
    return sortWith(v, Order.getOrderFor(v[0]));
  }
  
  static public function sortWith<T>(v : Array<T>, order : Ord<T>): Array<T> {
    var r = v.copy();
    r.sort(order);
    return r;
  }
  @:noUsing static public function compare<T>(v1: Array<T>, v2: Array<T>) {
      return compareWith(v1, v2, Order.getOrderFor(v1[0]));
  } 
  
  static public function compareWith<T>(v1: Array<T>, v2: Array<T>, order : Ord<T>) {  
    var c = v1.length - v2.length;
    if(c != 0)
      return c; 
    if(v1.length == 0)
      return 0;                       
      for (i in 0...v1.length) {
        var c = order(v1[i], v2[i]);   
        if (c != 0) return c;
      }
      return 0;
  }
}
class ProductOrder {
	static public function getOrder(p:Product, i : Int) {
    return Order.getOrderFor(p.element(i));
  }
	static public function compare(one:Product, other:Product): Int {
    for (i in 0...one.length) {
      var c = getOrder(one, i)(one.element(i), other.element(i));
      if(c != 0)
        return c;
    }
    return 0;
  }
}
class Orders{
  static public function greaterThan<T>(order : Ord<T>): Eq<T> {
    return function(v1, v2) return order(v1, v2) > 0;
  }  
   
  static public function greaterThanOrEqual<T>(order : Ord<T>): Eq<T> {
     return function(v1, v2) return order(v1, v2) >= 0;
  }  

  static public function lessThan<T>(order : Ord<T>): Eq<T> {
    return function(v1, v2) return order(v1, v2) < 0;
  }  

  static public function lessThanOrEqual<T>(order : Ord<T>): Eq<T> {
     return function(v1, v2) return order(v1, v2) <= 0;
  }

  static public function equal<T>(order : Ord<T>): Eq<T> {
     return function(v1, v2) return order(v1, v2) == 0;
  }

  static public function notEqual<T>(order : Ord<T>): Eq<T> {
     return function(v1, v2) return order(v1, v2) != 0;
  }
}