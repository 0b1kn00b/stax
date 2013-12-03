package stx;

import stx.type.*;
import stx.Either;
import Prelude;
import stx.Compare;

using stx.Option;

typedef Any = Dynamic;

class Anys {
	/**
	  Takes a value, applies a Function1 to the value and returns the original value.
	  @param 	a			Any value.
	  @param 	f			Modifier function.
	  @return 	a			The input value after f(a).
	 */
  static public function affect<T>(t: T, f: T->Void): T {
    f(t);
    
    return t;
  }
	
	/**
	  Returns a Thunk that will always return the input value t.
	  @param 		t		Any value
	  @return 				A function that will return the input value t.
	 */
  static public function toThunk<T>(t: T): Thunk<T> {
    return function() {
      return t;
    }
  }  
  /**
    Applies a function 'f' to a valuse of any Type.
  */
  static public function use<A,B>(v:A,fn:A->Void):Void{
  	fn(v);
  }
  /**
    Applies Function1 f to value a and returns the result.
    @param      a     Any value.
    @param      f     Modifier function.
    @usage a.into( function(x) return ... )
   */
  static public function to<A, B>(a: A, f: A -> B): B {
    return f(a);
  }
  /**
    Drops value a, returns b
  */
  static public function exchange<A,B>(a:A,b:B):B{
  	return b;
  }
  /**
    Check if ´v´ is null, returns result of ´fn´ if not.
  */
  static public function orIfNull<A>(v:A,fn:Thunk<A>):A{
    return Options.create(v).valOrTry(fn);
  }
  public static function equals<T1, T2>(value0 : T1, value1 : T2, ?func : T1 -> T2 -> Bool ) : Bool {
    if (func == null) {
      func = function(a, b) {
          var type0 = Type.typeof(a);
          var type1 = Type.typeof(b);
          if (Type.enumEq(type0, type1)) {
              return switch(type0) {
                  case TEnum(_) : 
                  var _a : EnumValue = cast a;
                  var _b : EnumValue = cast b;
                  Type.enumEq(_a,_b);
                  case _: cast a == cast b;
              }
          }
          return false;
      };
    }
    return func(value0, value1);
  }

    public static function getName<T>(value : T)  : String {
        return switch(Type.typeof(value)) {
            case TUnknown   : 'unknown';
            case TObject    : try Type.getClassName(cast value) catch(e:Dynamic) Std.string(value);
            case TNull      : 'null';
            case TInt       : 'int';
            case TFunction  : 'function';
            case TFloat     : 'float';
            case TEnum(e)   : '${Type.getEnumName(e)}.${Type.enumConstructor(cast value)}';
            case TClass(e)  : Type.getClassName(e);
            case TBool      : 'bool';
        }
    }

    public static function getSimpleName<T>(value : T)  : String {
        function extract(name : String) {
            var runtimeIndexName = name.indexOf('{');
            return if (runtimeIndexName >= 0) 'Unknown';
            else name.substr(name.lastIndexOf(".") + 1);
        }

        var name = getName(value);
        return switch (Type.typeof(value)) {
            case TObject: extract(name);
            case TClass(_): extract(name);
            case _: name;
        }
    }

    public static function getClass<T>(value : T) : Class<T> return Type.getClass(value);

    inline public static function isTypeOf<T>(value : T, possible : String) : Bool {
        var value = switch(Type.typeof(value)) {
            case TUnknown   : 'unknown';
            case TObject    : 'object';
            case TNull      : 'null';
            case TInt       : 'int';
            case TFunction  : 'function';
            case TFloat     : 'float';
            case TEnum(_)   : 'enum';
            case TClass(_)  : 'class';
            case TBool      : 'bool';
        }
        return value == possible;
    }

    public static function isObject<T>(value : T) : Bool return isTypeOf(value, 'object');
    public static function isNull<T>(value : T) : Bool return isTypeOf(value, 'null');
    public static function isInt<T>(value : T) : Bool return isTypeOf(value, 'int');
    public static function isFunction<T>(value : T) : Bool return isTypeOf(value, 'function');
    public static function isFloat<T>(value : T) : Bool return isTypeOf(value, 'int');
    public static function isEnum<T>(value : T) : Bool return isTypeOf(value, 'enum');
    public static function isClass<T>(value : T) : Bool return isTypeOf(value, 'class');
    public static function isBoolean<T>(value : T) : Bool return isTypeOf(value, 'bool');

    public static function isPrimitive<T>(v:T):Bool{
        return switch (Type.typeof(v)) {
            case TInt, TFloat, TBool : true;
            default                  : false;
        }
    }
    public static function asInstanceOf<T : Any, R>(value : T, possible : Class<R>) : R {
        // Runtime cast, rather than a compile type cast.
        return isInstanceOf(value, possible) ? cast value : throw 'Cannot cast $value to $possible';
    }

    public static function isInstanceOf<T : Any>(value : T, possible : Any) : Bool {
        // Performance optimisation.
        #if js
        untyped {
            if(__js__('value === null || possible === null')) return false;

            if(__js__('typeof(possible) === "function"')) {
                if(__js__("value instanceof possible")) {
                    if(possible == Array) return (value.__enum__ == null);
                    return true;
                }

                if(__interfLoop(value.__class__, possible)) return true;
            }

            switch(possible) {
                case Int        : return __js__("Math.ceil(value % 2147483648.0) === value");
                case Float      : return __js__("typeof(value)") == "number";
                case Bool       : return __js__("value === true || value === false");
                case String     : return __js__("typeof(value)") == "string";
                case Dynamic    : return true;
                default:
                    // do not use isClass/isEnum here
                    __feature__("Class.*", if(possible == Class && value.__name__ != null) return true);
                    __feature__("Enum.*", if(possible == Enum && value.__ename__ != null) return true);
                    return value.__enum__ == possible;
            }
        }
        #else
        return Std.is(value, possible);
        #end
    }

    public static function isValueOf<T : Any>(value : T, possible : Any) : Bool {
        return if (value == null || possible == null) false;
        else switch(Type.typeof(value)) {
            case TEnum(_) if(isInstanceOf(possible, Enum)): Type.getEnum(value) == possible;
            case TEnum(_) if(isEnum(possible) && Type.enumEq(value, possible)): true;
            case _: equals(value, possible);
        }
    }

    public static function toBool<T>(value : Null<T>) : Bool {
        return if(value == null) false;
        else if(isInstanceOf(value, Bool)) cast value;
        else if(isInstanceOf(value, Float) || isInstanceOf(value, Int)) cast(value) > 0;
        else if(isInstanceOf(value, String)) Strings.isNotEmpty(cast value);
        else if(isInstanceOf(value, Option)) Options.toBool(cast value);
        else if(isInstanceOf(value, Either)) Eithers.toBool(cast value);
        else true;
    }

    public static function toString<T>(value : T, ?func : T->String) : String {
        // NOTE (Simon) : Workout if the value has a toString method
        return if(toBool(func)) func(value);
        else Std.string(value);
    }
    private static function __interfLoop(cc : Dynamic, cl : Dynamic) {
        if(cc == null) return false;
        if(cc == cl) return true;

        var intf : Dynamic = cc.__interfaces__;
        if(intf != null) {
            for(i in 0...intf.length) {
                var i : Dynamic = intf[i];
                if(i == cl || __interfLoop(i,cl)) return true;
            }
        }
        return __interfLoop(cc.__super__,cl);
    }
}