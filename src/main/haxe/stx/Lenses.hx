package stx;
using Type;
using stx.Predicates;
using stx.Bools;

import stx.Prelude;

class Lenses{
	@:note("#0b1kn00b: heavens knows what the typer will make of this, there's no way of knowing what the type of B will be here")
	public static function lense<A,B>(object:A,fieldname:String):Lense<A,B>{

		return 
			Predicates.isNotNull()(object)
				.and( Predicates.isNotNull()(fieldname) )
				.ifElse(
					function(){	
						return 
						{
							get : function(object:A):B {
											return Reflect.field(object,fieldname);
										},
							set : function(object:A,fieldvalue:B):A {
											Reflect.setField(object,fieldname,fieldvalue);
											return object;
										}
						}
					},
					function(){
						throw new stx.error.NullReferenceError('');
						return null;
					}
				);
	}
	public static function create<A,B>(getter : A -> B, setter : A -> B -> A):Lense<A,B>{
		return {
			get : getter,
			set : setter
		}
	}
}