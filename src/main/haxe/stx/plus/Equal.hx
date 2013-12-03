package stx.plus;

import haxe.ds.StringMap;
 
import Type;

using stx.Tuples;
using stx.Option;
using stx.Iterators;
using Prelude;
using stx.Arrays;

@:note('#0b1kn00b: The assumption that the right hand value is of the correct type could be questioned')
class Equal{
  /*static public function equals<T>(a:T,b:T,?func:T->T->Bool):Bool{
    if (func == null){
      func = getEqualFor(a);
    }
    return func(a,b);
  }
  static public function equals_Equals<T:{equals : T -> T -> Bool}>(a:T,b:T,?func:T->T->Bool):Bool{
    return if (func!=null){
      func(a,b);
    }else if(a!=null){
      __equals__(a.equals)(a,b);
    }else if (b!=null){
      __equals__(b.equals)(a,b);
    }
  }*/
  static public function getEqualFor<T>(v:T):Eq<T>{
    return getEqualForType(Type.typeof(v));
  }
  static public function getEqualForType<T>(v: ValueType):Eq<T>{
    return switch (v){
      case TNull                                                        : NullEqual.equals;
      case TInt,TFloat,TBool                                            : __equals__(inline function(x,y) return x == y);
      case TFunction                                                    : __equals__(Reflect.compareMethods); 
      case TClass( c ) if ( c == StringMap  )                           : __equals__(StringMapEqual.equals);
      case TClass( c ) if ( c == Array  )                               : __equals__(ArrayEqual.equals);
      case TClass( c ) if ( c == Date   )                               : __equals__(stx.Dates.equals);
      case TClass( c ) if ( c == String )                               : __equals__(stx.Strings.equals);
      case TEnum(_)                                                     : __equals__(EnumEqual.equals);
      case TClass( c )                                                  :
        if(Type.getInstanceFields(c).remove("equals")){
          __equals__(EqualsEquals.equals);
        }else{
          __equals__(UnsupportedClassEqual.equals);
        }
      case TObject      : __equals__(ObjectEquals.equals);
      case TUnknown     : __equals__(
        inline function(x,y){
          return if(Reflect.hasField(x,'equals')){
            EqualsEquals.equals(x,y);
          }else{
            ObjectEquals.equals(x,y);
          }
        }
      );
    }
  }
  public static inline function  __equals__<A>(impl:Eq<Dynamic>):Eq<A> {
    return inline function(a, b) {
      return if(a == b || (a == null && b == null)) true;
        else if(a == null || b == null) false;
        else impl(a, b);
    };
  }
}
class UnsupportedClassEqual{
  @:noUsing static public inline function equals<T>(a:T,b:T):Bool{
    return ObjectEquals.equals(a,b) && (Type.getClass(a) == Type.getClass(b));
  }
}
class NullEqual{
  @:noUsing static public inline function equals<T:Null<Dynamic>>(a:T,b:T){
    return (a == null) && (b == null);
  }
}
class ObjectEquals{
  static public inline function equals<A>(a:Dynamic,b:Dynamic){
    var o = true;
    for(key in Reflect.fields(a)) {
      var va = Reflect.field(a, key);
      if(!Equal.getEqualFor(va)(va, Reflect.field(b, key))){
        o = false;break;
      }
    }
    return o;
  }
}
class OptionEqual{
  static public inline function equals<A>(op0:Option<A>,op1:Option<A>):Bool{
    return op0.zip(op1).map(
      function(l:A,r:A){
        return Equal.getEqualFor(l)(l,r);
      }.tupled()
    ).valOrTry(
      function(){
        return op0.isEmpty() && op1.isEmpty();
      }
    );
  }
}
class ProductEquals{
  static public inline function equals(a:Product,b:Product){
    var els0  = a.elements();
    var els1  = b.elements();
    var o     = true;
    if(els0.length != els1.length){ o  = false; }
    else{
      for (idx in 0...els0.length){
        var l = els0[idx];
        var r = els1[idx];
        if( Equal.getEqualFor(l)(l,r) == false){
          o = false;
          break;
        }
      }
    }
    return o;
  }
}
class StringMapEqual{
  static public inline function equals<A>(a:StringMap<A>,b:StringMap<A>){
    return ArrayEqual.equals( a.keys().zip(a.iterator()).toArray(), b.keys().zip(b.iterator()).toArray() );
  }
}
class EqualsEquals{
  static public inline function equals<A>(a:{ equals : A -> Bool },b:Dynamic){
    return a.equals(b);
  }
}
class EnumEqual{
  @:noUsing static public inline function equals(a:Dynamic,b:Dynamic){
    return if(0 != Type.enumIndex(a) - Type.enumIndex(b)){
      false;
    }else{
      var pa  = Enums.params(a);
      var pb  = Enums.params(b);
      var b   = true;
      for(i in 0...pa.length) {
        if(!Equal.getEqualFor(pa[i])(pa[i], pb[i]))
          b = false;
      }
      b;
    }
  }
}
class ArrayEqual {
  public static inline function equals<T>(v1: Array<T>, v2: Array<T>) {
    return equalsWith(v1, v2, Equal.getEqualFor(v1[0]));
  }
  public static inline function equalsWith<T>(v1: Array<T>, v2: Array<T>, equal : Eq<T>) { 
    var o = (equal != null);

    return if(!o){
      o;
    }else if (v1.length != v2.length) {
      false;
    }else if (v1.length == 0) { 
      true;
    }else{
      for (i in 0...v1.length) {
        if (!equal(v1[i], v2[i])) {
          o = false;
          break;
        }
      }
      o;
    }
  }
}