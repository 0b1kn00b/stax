package stx.plus;

												using Std;
import Type;

using stx.Tuples;			using stx.Tuples;
import stx.Maths;

using stx.Prelude;
												using stx.plus.Order;

typedef OrderFunction<T>        = Function2<T, T, Int>;

class Order {

	static function _createOrderImpl<T>(impl : OrderFunction<Dynamic>) : OrderFunction<T> {
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
      _createOrderImpl(function(a:A, b:A) { return Prelude.error()("at least one of the arguments should be null"); })(a,b);
  } 
  /** Returns a OrderFunction (T -> T -> Int). It works for any type expect TFunction.
   *  Custom Classes must provide a compare(other : T) : Int method or an exception will be thrown.
   */
  static public function getOrderFor<T>(t : T) : OrderFunction<T> {
    return getOrderForType(Type.typeof(t));
  }
  static public function getOrderForType<T>(v: ValueType) : OrderFunction<T> {
    return switch(v) {
    case TBool:
      _createOrderImpl(Bools.compare);
    case TInt:
      _createOrderImpl(Ints.compare);
    case TFloat:
      _createOrderImpl(Floats.compare);
    case TUnknown:
      function(a : T, b : T) return (a == b) ? 0 : ((cast a) > (cast b) ? 1 : -1);
    case TObject:
      _createOrderImpl(function(a, b) {
        for(key in Reflect.fields(a)) {
          var va = Reflect.field(a, key);
					var vb = Reflect.field(b, key);
          var v = getOrderFor(va)(va, vb);
          if(0 != v)
            return v;
        }
        return 0;
      });
    case TClass(c):
      switch(Type.getClassName(c)) {
      case "String":
        _createOrderImpl(Strings.compare);
      case "Date":
        _createOrderImpl(Dates.compare);
      case "Array":
        _createOrderImpl(ArrayOrder.compare);
      case "stx.Tuple2" , "stx.Tuple3" , "stx.Tuple4" , "stx.Tuple5" :
          _createOrderImpl(ProductOrder.compare);
      default:
        if(Meta._hasMetaDataClass(c)) {
          
          var i = 0;
          var fields = Type.getInstanceFields(c).map(function(v){
            var fieldMeta = Meta._getMetaDataField(c, v);
            var weight = if (fieldMeta != null && Reflect.hasField(fieldMeta, "order"))
              Reflect.field(fieldMeta, "order");
            else
              1;
            return Tuples.t3(v, weight, if(fieldMeta != null && Reflect.hasField(fieldMeta, "index")) Reflect.field(fieldMeta, "index"); else i++);                
          }).filter(function(v){return v.snd() != 0;}).sortWith(function(a, b) {
            var c = a.thd() - b.thd();
            if(c != 0)
              return c;
            return Strings.compare(a.fst(), b.fst());
          });
		      _createOrderImpl(function(a, b) {       
            var values = fields.filter(function(v) return !Reflect.isFunction(Reflect.field(a, v.fst()))).map(function(v){return Tuples.t3(Reflect.field(a, v.fst()), Reflect.field(b, v.fst()), v.snd());});
            for (value in values) {
              var c = getOrderFor(value.fst())(value.fst(), value.snd()) * value.thd();
              if (c != 0) return c;
            }

            return 0;
          });
		    } else if(Type.getInstanceFields(c).remove("compare")) {
          _createOrderImpl(function(a, b) return (cast a).compare(b));
   		  } else {
          Prelude.error()("class "+Type.getClassName(c)+" is not comparable");
        }
      }
    case TEnum(_):
        _createOrderImpl(function(a, b) {
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
    });
    case TNull:
      nil;
    case TFunction:
				Prelude.error()("unable to compare on a function");
    }
  }
}
class ArrayOrder {
	static public function sort<T>(v : Array<T>) : Array<T> {
    return sortWith(v, Order.getOrderFor(v[0]));
  }
  
  static public function sortWith<T>(v : Array<T>, order : OrderFunction<T>) : Array<T> {
    var r = v.copy();
    r.sort(order);
    return r;
  }
  static public function compare<T>(v1: Array<T>, v2: Array<T>) {
      return compareWith(v1, v2, Order.getOrderFor(v1[0]));
  } 
  
  static public function compareWith<T>(v1: Array<T>, v2: Array<T>, order : OrderFunction<T>) {  
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
  static public function greaterThan<T>(order : OrderFunction<T>) : EqualFunction<T> {
    return function(v1, v2) return order(v1, v2) > 0;
  }  
   
  static public function greaterThanOrEqual<T>(order : OrderFunction<T>) : EqualFunction<T> {
     return function(v1, v2) return order(v1, v2) >= 0;
  }  

  static public function lessThan<T>(order : OrderFunction<T>) : EqualFunction<T> {
    return function(v1, v2) return order(v1, v2) < 0;
  }  

  static public function lessThanOrEqual<T>(order : OrderFunction<T>) : EqualFunction<T> {
     return function(v1, v2) return order(v1, v2) <= 0;
  }

  static public function equal<T>(order : OrderFunction<T>) : EqualFunction<T> {
     return function(v1, v2) return order(v1, v2) == 0;
  }

  static public function notEqual<T>(order : OrderFunction<T>) : EqualFunction<T> {
     return function(v1, v2) return order(v1, v2) != 0;
  }
}