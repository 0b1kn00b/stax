package stx;

import stx.Errors;
import stx.Prelude;
import stx.Error.*;

using stx.Predicates;

using stx.Tuples;
import stx.Options;

using stx.Options;
using stx.Objects;
using stx.Arrays;
using stx.Prelude;
using stx.Eithers;
using stx.Compose;
using stx.Functions;

class Reflects{
	static public function callFunction<A>(v:A,key:String,?args:Array<Dynamic>):Dynamic{
		args = args == null ? [] : args;
		return Reflect.callMethod(v,Reflect.field(v,key),args);
	}
	static public function callMethod<A>(v:A,func:Dynamic,?args:Array<Dynamic>):Dynamic{
		args = args == null ? [] : args;
		return Reflect.callMethod(v,func,args);
	}
	static public function callSafe<A>(v:A,key:String,?args:Array<Dynamic>):Option<Dynamic>{
    return getFieldOption(v,key).map(callMethod.bind(v,_,args));
  }
  static public function callSecure<A>(v:A,key:String,?args:Array<Dynamic>):Outcome<Dynamic>{
    return getFieldOption(v,key).orEitherC(err(OutOfBoundsError())).flatMapR(
      function(x){
        return try{
          Right(callMethod(v,x,args));
        }catch(e:Error){
          Left(e);
        }catch(e:Dynamic){
          Left(err(e));
        }
      }
    );
  }
	static public function setFieldTuple<A,B>(v:A,t:Tuple2<String,B>):A{
		Reflect.setField(v,t.fst(),t.snd());
		return v;
	}
	static public function getFieldOption<A,B>(v:A,key:String):Option<B>{
		return Options.create( Reflect.field(v,key) );
	}
	static public function getField<A,B>(v:A,key:String):Null<B>{
		return Reflect.field(v,key);
	}
	static public function setField<A,B>(o:A,key:String,v:B):A{
		Reflect.setField(o,key,v);
		return o;
	}
	static public function getterOption<A,B>(fieldname:String):A->Option<B>{
		return getField.p2(fieldname);
	}
	static public function getter<A,B>(fieldname:String):A->B{
		return Reflect.field.p2(fieldname);
	}
	static public function extractFieldsFromAny<A>(v:A):Array<Tuple2<String,Dynamic>>{
    var u : Object = cast v;
		return Types.extractAllAnyFromTypeOption(v)
			.getOrElse(
				Objects.extractAllAny.lazy(u)
			);	
	}
	static public function extractProperties<A>(v:A):Array<Tuple2<String,Dynamic>>{
		return extractFieldsFromAny(v).filter(
			Reflect.isFunction.not().second().snd()
		);
	}
}