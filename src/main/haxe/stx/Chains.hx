package stx;

using stx.Compose;

class Chains{
	@:noUsing
	static public function _3<A,B,C,D>(a:A->B,b:B->C,c:C->D):A->D{
		return a.then(b).then(c);
	}
	@:noUsing
	static public function _4<A,B,C,D,E>(a:A->B,b:B->C,c:C->D,d:D->E):A->E{
		return a.then(b).then(c).then(d);
	}
	@:noUsing
	static public function _5<A,B,C,D,E,F>(a:A->B,b:B->C,c:C->D,d:D->E,e:E->F):A->F{
		return a.then(b).then(c).then(d).then(e);
	}
}