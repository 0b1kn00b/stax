package stx.plus;

using stx.Prelude;


import Type;
using stx.Strings;

import stx.plus.Show;
import stx.Tuples;										using stx.Tuples;
using stx.plus.Hasher;

typedef MapFunction<T>         = Function1<T, Int>; 

class Hasher {
	static function _createMapImpl<T>(impl : MapFunction<Dynamic>) return function(v : T) if(null == v) return 0 else return impl(v);

  /** 
    Returns a MapFunction (T -> Int). It works for any type. For Custom Classes you must provide a hashCode()
    method, otherwise the full class name is returned.
   */
  public static function getMapFor<T>(t : T) : MapFunction<T> {
    return getMapForType(Type.typeof(t));
  }
  public static function getMapForType<T>(v: ValueType) : MapFunction<T> {
    return switch(v) {
      case TBool:
        _createMapImpl(BoolHasher.hashCode);
      case TInt:
        _createMapImpl(IntHasher.hashCode);
      case TFloat:
        _createMapImpl(FloatHasher.hashCode);
      case TUnknown:
      _createMapImpl(function(v : T) return Prelude.error()("can't retrieve hascode for TUnknown: " + v));
      case TObject:
        _createMapImpl(function(v){
        var s = Show.getShowFor(v)(v);
        return getMapFor(s)(s);
        });
      case TClass(c):
        switch(Type.getClassName(c)) {
        case "String":
          _createMapImpl(StringHasher.hashCode);
        case "Date":
          _createMapImpl(DateHasher.hashCode);
        case "Array":
          _createMapImpl(ArrayHasher.hashCode);
        case "stx.Tuple2" , "stx.Tuple3" , "stx.Tuple4" , "stx.Tuple5" :
          _createMapImpl(ProductHasher.hashCode);
        default:
          var fields = Type.getInstanceFields(c);
          if(Meta._hasMetaDataClass(c)) {       
            var fields = Meta._fieldsWithMeta(c, "equalMap");
            _createMapImpl(function(v : T) {
              var className = Type.getClassName(c);
              var values    = fields.map(function(f){return Reflect.field(v, f);}).filter(function(v) return !Reflect.isFunction(v));
              return values.foldl(9901 * StringHasher.hashCode(className), function(v, e){return v + (333667 * (Hasher.getMapFor(e)(e) + 197192));});
            });
          } else if(Type.getInstanceFields(c).remove("hashCode")) {
            _createMapImpl(function(v) return Reflect.callMethod(v, Reflect.field(v, "hashCode"), []));
          } else {
            Prelude.error()("class does not have a hashCode method");
          }
        }
      case TEnum(_):
        _createMapImpl(function(v : T) { 
        var hash = Type.enumConstructor(cast v).hashCode() * 6151;
        for(i in Type.enumParameters(cast v))
          hash += Hasher.getMapFor(i)(i) * 6151;
        return hash;
      });
      case TFunction:
        _createMapImpl(function(v : T) return Prelude.error()("function can't provide a hash code"));
      case TNull:
        nil;
      /*_ :
      function(v : T) return -1;*/
    }
	}
  @:noUsing
  static public function nil<A>(v:A):Int { return 0;}
}
class ArrayHasher {
	public static function hashCode<T>(v: Array<T>) {
    return hashCodeWith(v, Hasher.getMapFor(v[0]));
  }
	public static function hashCodeWith<T>(v: Array<T>, hash : MapFunction<T>) {
    var h = 12289;
    if(v.length == 0) return h;
    for (i in 0...v.length) {
      h += hash(v[i]) * 12289;
    }
    
    return h;
  }  
}
class StringHasher {
	  public static function hashCode(v: String) {
    var hash = 49157;
    
    for (i in 0...v.length) {       
#if neko
      hash += (24593 + v.charCodeAt(i)) * 49157;
#else
      hash += (24593 + untyped v.cca(i)) * 49157;
#end
    }   
    return hash;
  }
}
class DateHasher {
	  public static function hashCode(v: Date) {
    return Math.round(v.getTime() * 49157);
  }
}
class FloatHasher {
	public static function hashCode(v: Float) {
    return Std.int(v * 98317); 
	}
}
class IntHasher {
	public static function hashCode(v: Int) : Int {
    return v * 196613;
  }
}
class BoolHasher {
	public static function hashCode(v : Bool) : Int {
    return if (v) 786433 else 393241;  
  }
}
class ProductHasher {
  static function __init__(){
    _baseMapes 
      = [
          [786433, 24593],
          [196613, 3079, 389],
          [1543, 49157, 196613, 97],
          [12289, 769, 393241, 193, 53]
        ];
  }
	static public function getMap(p:Product, i : Int) {
    return Hasher.getMapFor(p.element(i));
  }
  static var _baseMapes : Array<Array<Int>>;

  public static function hashCode(p:Product) : Int {
    var h = 0;
    for(i in 0...p.length){
      h += ProductHasher._baseMapes[p.length-2][i] * getMap(p,i)(p.element(i));
    }
    return h;
  }
}