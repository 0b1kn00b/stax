package stx;

using stx.Compose;

class Chains{
	static public function then3<A,B,C,D>(a:A->B,b:B->C,c:C->D):A->D{
		return a.then(b).then(c);
	}
	static public function then4<A,B,C,D,E>(a:A->B,b:B->C,c:C->D,d:D->E):A->E{
		return a.then(b).then(c).then(d);
	}
	static public function then5<A,B,C,D,E,F>(a:A->B,b:B->C,c:C->D,d:D->E,e:E->F):A->F{
		return a.then(b).then(c).then(d).then(e);
	}
}