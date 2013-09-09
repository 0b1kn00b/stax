package stx;

import Stax.*; 
import stx.plus.Order;
import stx.Fail;
import stx.Prelude;

using stx.Compare;

using stx.Tuples;
import stx.Options;

using stx.Anys;
using stx.Types;
using stx.Options;
using stx.Objects;
using stx.Arrays;
using stx.Prelude;
using stx.Eithers;
using stx.Compose;
using stx.Functions;

class Reflects{
  /**
    No error handling, Gets the value of field key as a reference before calling it on `v`
  */
	static public function callFunction<A>(v:A,key:String,?args:Array<Dynamic>):Dynamic{
		args = args == null ? [] : args;
		return Reflect.callMethod(v,Reflect.field(v,key),args);
	}
  /**
    No error handling, `func` is a function reference.
  */
	static public function callMethod<A>(v:A,func:Dynamic,?args:Array<Dynamic>):Dynamic{
		args = args == null ? [] : args;
		return Reflect.callMethod(v,func,args);
	}
  /**
    Partial error handling. If the method raises an error, it will propagate
  */
	static public function callSafe<A>(v:A,key:String,?args:Array<Dynamic>):Option<Dynamic>{
    return option(getValue(v,key)).map(callMethod.bind(v,_,args));
  }
  /**
    Full error handling, any errors raised will be passed back on the left hand side.
  */
  @:bug('#0b1kn00b: issue with __instanceof in nodejs')
  static public function callSecure<A>(v:A,key:String,?args:Array<Dynamic>):Outcome<Dynamic>{
    return option(getValue(v,key)).orEitherC(fail(OutOfBoundsFail())).flatMapR(
      function(x){
        /*return try{
          Right(callMethod(v,x,args));
        }catch(e:Fail){
          Left(e);
        }catch(e:Dynamic){
          Left(fail(e));
        }*/
        return try{
          Right(callMethod(v,x,args));
        }catch(d:Dynamic){
          Left(switch(Type.typeof(d)){
            case TClass(c) if (c.descended(Fail))  : d;
            default                                 : fail(NativeFail(d));
          });
        }
      }
    );
  }
  /**
    Convenience method for accumulating fields in folds
  */
	static public function setFieldTuple<A,B>(v:A,t:Tuple2<String,B>):A{
		Reflect.setField(v,t.fst(),t.snd());
		return v;
	}
  /**
    Returns the value of fields `key`, null if it does not exist or is null.
  */
  static public function getValue<A,B>(v:A,key:String):Null<B>{
    return Reflect.field(v,key);
  }
  /**
    Returns the value of fields `key`, null if it does not exist or is null.
  */
	static public function getField<A,B>(v:A,key:String):Null<KV<B>>{
		return tuple2(key,Reflect.field(v,key));
	}
  /**
    Sets the value of field key.
  */
	static public function setField<A,B>(o:A,key:String,v:B):A{
		Reflect.setField(o,key,v);
		return o;
	}
  /**
    Produces a dynamic getter with an Option output.
  */
	static public function getterOption<A,B>(fieldname:String):A->Option<B>{
		return getValue.bind(_,fieldname);
	}
  /**
    Produces a dynamic getter for field `fieldname`.
  */
	static public function getter<A,B>(fieldname:String):A->B{
		return Reflect.field.bind(_,fieldname);
	}
  /**
    Gets the types fields or the reflected fields from `v`
  */
	static public function fields<A>(v:A):Array<KV<Dynamic>>{
    var u : Object = cast v;
		return Objects.fields(u);
	}
  /**
    Gets the types keys or the reflected fields from `v`
  */
  static public function keys<A>(v:A):Array<String>{
    return Reflect.fields(v);
  }
  /**
    Does a dynamic validation for proposed fields to be copied to type T. Returns
    the set of keys found in `flds` not present.
  */
  static public function validate<T>(cls:Class<T>,flds:Array<String>):Array<String>{
    var l       = ArrayOrder.sort(cls.locals());
    var r       = ArrayOrder.sort(flds);
    return l.foldl(
        [],
        function(memo,next){
          if (!r.forAny(
            function(x){
              return stx.Strings.equals(x,next);
            }
          )){
            memo.push(next);
          }
          return memo;
        }
      );
  }
  /**
    Compares the fields of the two objects
  */
  @:noUsing static public function compare(o0:Dynamic,o1:Dynamic):Int{
    return ArrayOrder.compare(ArrayOrder.sort(fields(o0)),ArrayOrder.sort(fields(o1)));
  }
}