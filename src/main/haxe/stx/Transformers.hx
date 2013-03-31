package stx;

using stx.Maybes;
using stx.Tuples;

typedef Tfs 	= Transformers;
typedef Tfs2 	= Transformers2;
typedef Tfs3 	= Transformers3;
typedef Tfs4 	= Transformers4;

class Transformers{
	static public function adjoin<A,B,C,D>(f0:A->B,f1:C->D):Tuple2<A,C>->Tuple2<B,D>{
		return 
			function(t:Tuple2<A,C>){
				return Tuples.t2(f0(t.fst()),f1(t.snd()));
			}
	}
}
class Transformers2{
	@:noUsing
	static public function create<A,B,C,D>(f0:A->B,f1:C->D):Tuple2<A,C>->Tuple2<B,D>{
		return 
			function(t:Tuple2<A,C>){
				return Tuples.t2(f0(t.fst()),f1(t.snd()));
			}
	}
	static public function adjoin<A,B,C,D,E,F>(f0:Tuple2<A,C>->Tuple2<B,D>,f1:E->F){
		return 
			function(t:Tuple3<A,C,E>):Tuple3<B,D,F>{
				var r1 = f0(Tuples.t2(t.fst(),t.snd()));
				return Tuples.t3(r1.fst(),r1.snd(),f1(t.thd()));
			}
	}
}
class Transformers3{
	@:noUsing
	static public function create<A,B,C,D,E,F>(?f0:A->B,?f1:C->D,?f2:E->F):Tuple3<A,C,E>->Tuple3<B,D,F>{
		f0 = Maybes.create(f0).getOrElse(cast Compose.pure);
		f1 = Maybes.create(f1).getOrElse(cast Compose.pure);
		f2 = Maybes.create(f2).getOrElse(cast Compose.pure);
		return 
			function(t:Tuple3<A,C,E>){
				return 
					Tuples.t3(f0(t.fst()),f1(t.snd()),f2(t.thd()));
			}
	}
	static public function adjoin<A,B,C,D,E,F,G,H>(f0:Tuple3<A,C,E>->Tuple3<B,D,F>,f1:G->H):Tuple4<A,C,E,G>->Tuple4<B,D,F,H>{
		return 
			function(t:Tuple4<A,C,E,G>):Tuple4<B,D,F,H>{
				var r1 = f0(Tuples.t3(t.fst(),t.snd(),t.thd()));
				return Tuples.t4(r1.fst(),r1.snd(),r1.thd(),f1(t.frt()));
			}
	}
}
class Transformers4{
	@:noUsing
	static public function create<A,B,C,D,E,F,G,H>(f0:A->B,f1:C->D,f2:E->F,f3:G->H):Tuple4<A,C,E,G>->Tuple4<B,D,F,H>{
		return 
			function(t:Tuple4<A,C,E,G>){
				return 
					Tuples.t4(f0(t.fst()),f1(t.snd()),f2(t.thd()),f3(t.frt()));
			}
	}
	static public function adjoin<A,B,C,D,E,F,G,H,I,J>(f0:Tuple4<A,C,E,G>->Tuple4<B,D,F,H>,f1:I->J):Tuple5<A,C,E,G,I>->Tuple5<B,D,F,H,J>{
		return 
			function(t:Tuple5<A,C,E,G,I>):Tuple5<B,D,F,H,J>{
				var r1 = f0(Tuples.t4(t.fst(),t.snd(),t.thd(),t.frt()));
				return Tuples.t5(r1.fst(),r1.snd(),r1.thd(),r1.frt(),f1(t.fth()));
			}
	}
}
class Transformers5{
	@:noUsing
	static public function create<A,B,C,D,E,F,G,H,I,J>(f0:A->B,f1:C->D,f2:E->F,f3:G->H,f4:I->J):Tuple5<A,C,E,G,I>->Tuple5<B,D,F,H,J>{
		return 
			function(t:Tuple5<A,C,E,G,I>){
				return 
					Tuples.t5(f0(t.fst()),f1(t.snd()),f2(t.thd()),f3(t.frt()),f4(t.fth()));
			}
	}
}