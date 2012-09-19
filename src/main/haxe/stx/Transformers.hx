package stx;
import stx.Tuples;

class Transformers{
	static public function adjoin<A,B,C,D>(f0:A->B,f1:C->D):Tuple2<A,C>->Tuple2<B,D>{
		return 
			function(t:Tuple2<A,C>){
				return Tuples.t2(f0(t._1),f1(t._2));
			}
	}
}
class Transformers2{
	@:noUsing
	static public function create<A,B,C,D>(f0:A->B,f1:C->D):Tuple2<A,C>->Tuple2<B,D>{
		return 
			function(t:Tuple2<A,C>){
				return Tuples.t2(f0(t._1),f1(t._2));
			}
	}
	static public function adjoin<A,B,C,D,E,F>(f0:Tuple2<A,C>->Tuple2<B,D>,f1:E->F){
		return 
			function(t:Tuple3<A,C,E>):Tuple3<B,D,F>{
				var r1 = f0(Tuples.t2(t._1,t._2));
				return Tuples.t3(r1._1,r1._2,f1(t._3));
			}
	}
}
class Transformers3{
	@:noUsing
	static public function create<A,B,C,D,E,F>(f0:A->B,f1:C->D,f2:E->F):Tuple3<A,C,E>->Tuple3<B,D,F>{
		return 
			function(t:Tuple3<A,C,E>){
				return 
					Tuples.t3(f0(t._1),f1(t._2),f2(t._3));
			}
	}
	static public function adjoin<A,B,C,D,E,F,G,H>(f0:Tuple3<A,C,E>->Tuple3<B,D,F>,f1:G->H):Tuple4<A,C,E,G>->Tuple4<B,D,F,H>{
		return 
			function(t:Tuple4<A,C,E,G>):Tuple4<B,D,F,H>{
				var r1 = f0(Tuples.t3(t._1,t._2,t._3));
				return Tuples.t4(r1._1,r1._2,r1._3,f1(t._4));
			}
	}
}
class Transformers4{
	@:noUsing
	static public function create<A,B,C,D,E,F,G,H>(f0:A->B,f1:C->D,f2:E->F,f3:G->H):Tuple4<A,C,E,G>->Tuple4<B,D,F,H>{
		return 
			function(t:Tuple4<A,C,E,G>){
				return 
					Tuples.t4(f0(t._1),f1(t._2),f2(t._3),f3(t._4));
			}
	}
	static public function adjoin<A,B,C,D,E,F,G,H,I,J>(f0:Tuple4<A,C,E,G>->Tuple4<B,D,F,H>,f1:I->J):Tuple5<A,C,E,G,I>->Tuple5<B,D,F,H,J>{
		return 
			function(t:Tuple5<A,C,E,G,I>):Tuple5<B,D,F,H,J>{
				var r1 = f0(Tuples.t4(t._1,t._2,t._3,t._4));
				return Tuples.t5(r1._1,r1._2,r1._3,r1._4,f1(t._5));
			}
	}
}
class Transformers5{
	@:noUsing
	static public function create<A,B,C,D,E,F,G,H,I,J>(f0:A->B,f1:C->D,f2:E->F,f3:G->H,f4:I->J):Tuple5<A,C,E,G,I>->Tuple5<B,D,F,H,J>{
		return 
			function(t:Tuple5<A,C,E,G,I>){
				return 
					Tuples.t5(f0(t._1),f1(t._2),f2(t._3),f3(t._4),f4(t._5));
			}
	}
}