package stx;

import Prelude;

using stx.Functions;
using stx.Compose;

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
}