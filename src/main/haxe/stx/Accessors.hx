package stx;

using stx.Functions;

typedef Accessor<A> = {
	get : Void -> A,
	set : A -> Void
}
/**
	Generate dynamic field Accessors
*/
class Accessors{
	static public function create<A>(getter:Void->A,setter:A->Void){
		return {
			get : getter,
			set : setter
		}
	}
	/**
		
	*/
	static public function getter(s:String):Dynamic->Dynamic{
		return Reflect.field.p2(s);
	}
	static public function setter(s:String):Dynamic->Dynamic->Dynamic{
		return Reflect.setField.p2(s);
	}
}