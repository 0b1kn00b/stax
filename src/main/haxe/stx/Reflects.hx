package stx;

using stx.Predicates;
import stx.Prelude;
using stx.Tuples;
import stx.Options;

using stx.Options;
using stx.Objects;
using stx.Arrays;
using stx.Prelude;
using stx.Compose;
using stx.Functions;

typedef Field = Tup2<Dynamic,String>;

class Reflects{
	static public function setFieldTp<A,B>(v:A,t:Tuple2<String,B>):A{
		Reflect.setField(v,t.fst(),t.snd());
		return v;
	}
	static public function getFieldO<A,B>(v:A,key:String):Option<B>{
		return Options.create( Reflect.field(v,key) );
	}
	static public function getField<A,B>(v:A,key:String):Null<B>{
		return Reflect.field(v,key);
	}
	static public function setField<A,B>(o:A,key:String,v:B):A{
		Reflect.setField(o,key,v);
		return o;
	}
	static public function getterO<A,B>(fieldname:String):A->Option<B>{
		return getField.p2(fieldname);
	}
	static public function getter<A,B>(fieldname:String):A->B{
		return Reflect.field.p2(fieldname);
	}
	static public function extractObjectFromAny<A>(v:A):Object{
		return switch(Type.typeof(v)){
			case TClass(v) 	: Types.extractObjectFromType(v);
			default 				:	Objects.extractAll(cast v);
		}
	}
	static public function extractFieldsFromAny<A>(v:A):Array<Tup2<String,Dynamic>>{
		return Types.extractAllAnyFromType(v)
			.getOrElse(
				Objects.extractAllAny.lazy(cast v)
			);	
	}
	static public function extractProperties<A>(v:A):Array<Tup2<String,Dynamic>>{
		return extractFieldsFromAny(v).filter(
			Reflect.isFunction.not().second().sndOf()
		);
	}
}