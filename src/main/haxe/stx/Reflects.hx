package stx;

import stx.Prelude;
import stx.Tuples;
import stx.Options;

using stx.Options;
using stx.Objects;
using stx.Arrays;
using stx.Prelude;
using stx.Functions;

class Reflects{
	static public function setFieldTp<A,B>(v:A,t:Tuple2<String,B>):A{
		Reflect.setField(v,t._1,t._2);
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
	static public function setFieldMaybe<A,B>(v:A,fld:String,val:B):A{ 
			getField(v.copy(),fld)
				.foreach(
					function(x){
						Reflect.setField(v,fld,val);
					}
				);
		return v;
	}
	static public function getterO<A,B>(fieldname:String):A->Option<B>{
		return getField.p2(fieldname);
	}
	static public function getter<A,B>(fieldname:String):A->B{
		return Reflect.field.p2(fieldname);
	}
	static public function set<A,B>(object:A,field:String,value:B){
		Reflect.setField(object,field,value);
		return object;
	}
	static public function extractObjectFromAny<A>(v:A):Object{
		return 
			switch(Type.typeof(v)){
				case TClass(v) 	: Types.extractObjectFromType(v);
				default 				:	Objects.extractObject(v);
			}
	}
}