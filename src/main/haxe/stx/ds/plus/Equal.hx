package stx.ds.plus;

/**
 * ...
 * @author 0b1kn00b
 */

import SCore;											using SCore;
import stx.Tuples;								using stx.Tuples;

import stx.Prelude;
import Type;

import stx.Maths;

class Equal {

	/** 
   * Returns an EqualFunction (T -> T -> Bool). It works for any type. Custom Classes can provide
   * an "equals(other : T) : Bool" method or a "compare(other : T) : Int" method otherwise  simple comparison operators will be used.
   */
  public static function getEqualFor<T>(t : T) : EqualFunction<T> {
    return getEqualForType(Type.typeof(t));
  }
  public static function getEqualForType<T>(v: ValueType) : EqualFunction<T> {
    return switch(v) {
      case TBool:
        _createEqualImpl(Bools.equals);
      case TInt:
        _createEqualImpl(Ints.equals);
      case TFloat:
        _createEqualImpl(Floats.equals);
      case TUnknown:
      function(a : T, b : T) return a == b;
      case TObject:
        _createEqualImpl(function(a, b) {
        for(key in Reflect.fields(a)) {
          var va = Reflect.field(a, key);
          if(!getEqualFor(va)(va, Reflect.field(b, key)))
            return false;
        }
        return true;
      });
    case TClass(c):
      switch(Type.getClassName(c)) {
        case "String":
          _createEqualImpl(Strings.equals);
        case "Date":
          _createEqualImpl(Dates.equals);
        case "Array":
          _createEqualImpl(ArrayEqual.equals);
        case "stx.Tuple2" , "stx.Tuple3" , "stx.Tuple4" , "stx.Tuple5" :
          _createEqualImpl(ProductEqual.equals);
        default:    
          if(Meta._hasMetaDataClass(c)) {  
            var fields = Meta._fieldsWithMeta(c, "equalHash");
            _createEqualImpl(function(a, b) {         
              var values = fields.map(function(v){return Tuples.t2(Reflect.field(a, v), Reflect.field(b, v));});
              for (value in values) {
                if(Reflect.isFunction(value._1))
                  continue;
                if(!getEqualFor(value._1)(value._1, value._2))
                  return false;
              }
              return true;
            });    
          } else if(Type.getInstanceFields(c).remove("equals")) {
            _createEqualImpl(function(a, b) return (cast a).equals(b));
          }/*else{
            _createEqualImpl( function(a,b) return a == b );
          }*/
          else {
            SCore.error("class "+Type.getClassName(c)+" has no equals method");
          }
      }
    case TEnum(e):
      _createEqualImpl(function(a, b) {
        if(0 != Type.enumIndex(a) - Type.enumIndex(b))
          return false;
        var pa = Type.enumParameters(a);
        var pb = Type.enumParameters(b);
        for(i in 0...pa.length) {
          if(!Equal.getEqualFor(pa[i])(pa[i], pb[i]))
            return false;
        }
        return true;
      });
    case TNull:
      _createEqualImpl(function(a, b) return SCore.error("at least one of the arguments should be null"));
    case TFunction:
      _createEqualImpl(Reflect.compareMethods);
		}
  }
	static function _createEqualImpl<T>(impl : EqualFunction<Dynamic>) {
    return function(a, b) {
    return if(a == b || (a == null && b == null)) true;
      else if(a == null || b == null) false;
      else impl(a, b);
    };
  }
}
class ArrayEqual {
	 public static function equals<T>(v1: Array<T>, v2: Array<T>) {
    return equalsWith(v1, v2, Equal.getEqualFor(v1[0]));
  }
  
  public static function equalsWith<T>(v1: Array<T>, v2: Array<T>, equal : EqualFunction<T>) { 
    if (v1.length != v2.length) return false;
    if (v1.length == 0) return true;
    for (i in 0...v1.length) {
      if (!equal(v1[i], v2[i])) return false;
    }
    
    return true;
  }
}
class ProductEqual {
	static public function getEqual(p:Product,i : Int) {
    return Equal.getEqualFor(p.element(i));
  }
	static public function productEquals(p:Product, other : Product): Bool {
    for(i in 0...p.length)
      if(!getEqual(p,i)(p.element(i), other.element(i)))
        return false;
    return true;
  }
	static public function equals(p:Product, other:Product):Bool {
		for(i in 0...p.length)
      if(!getEqual(p,i)(p.element(i), other.element(i)))
        return false;
    return true;
	}
}