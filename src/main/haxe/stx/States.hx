package stx;
import stx.Prelude;
import stx.Tuples;		using stx.Tuples;
											using stx.Functions;
											using stx.Dynamics;
											using stx.States;

typedef State<S,R> = S -> Tuple2<R,S>;

class States{
	static public function apply<S,R>(state:State<S,R>,v:S):Tuple2<R,S>{
		return state(v);
	}
	static public function map<S,R,R1>(state:State<S,R>,fn:R->R1):State<S,R1>{
		return apply.p1(state).andThen( Tuple2.translate.p3( Stax.identity() ).p2( fn ) );
	}
	static public function mapS<S,R>(state:State<S,R>,fn:S->S):State<S,R>{
		return
			function(s:S){
				var o = state(s);
				return Tuples.t2( o._1, fn(o._2) );
			}
	}
	static public function flatMap<S,R,R1>(state:State<S,R>,fn:R->State<S,R1>):State<S,R1>{
		return apply.p1(state)
			.andThen( Tuple2.translate.p3( Stax.identity() ).p2( fn ) )
			.andThen(
				function(t:Tuple2<State<S,R1>,S>)	{
					return t._1(t._2);
				}
			);
	}
	static public function getS<S,R>(state:State<S,R>):State<S,S>{
		return 
			function(s:S){
				var o = state(s);
				return Tuples.t2(o,o);
			}
	}
	static public function putS(state:State<S,R>,n:S):State<S,R>){
		return 
			function (s:S){
				return Tuples.t2(null,nu);
			}
	}

	static public function stateOf<S>(v:S):State<S,Void>{
		return
			function(s:S){
				return Tuples.t2(null,s);
			}
	}
	static public function unit<S,A>(value:A):State<S,A>{
		return
			function(s:S):Tuple2<A,S>{
				return Tuples.t2(value,s);
			}
	}
}
class StateRef<S,A>{
	private var value : A;
	public function new(v:A){
		this.value = v;
	}
	public function read():State<S,A> {
		return States.unit(value);
	}
	public function write(a:A):State<S,StateRef<S,A>>{
		return 
			function(s:S){
				this.value = a;
				return Tuples.t2(this,s);
			}
	}
	public function modify(f:A->A):State<S,StateRef<S,A>> {
		var a = read();
		var v = a.flatMap(f.andThen(write));
		return v;
	}
	
	public static function newVar<S,A>(v:A):State<WorldState,StateRef<WorldState,A>>{
		return States.unit(	new StateRef(v));
	}
	public static function run<A>(v:State<WorldState,StateRef<WorldState,A>>){
		v( new WorldState() );
	}
}
class StateRefs{
	public static function modifier<S,A>(f:A->A,sr:StateRef<S,A>):State<S,StateRef<S,A>>{
		return sr.modify(f);
	}
	public static function reader<S,A>(sr:StateRef<S,A>):State<S,A>{
		return sr.read();
	}
}
private class WorldState{
	public function new(){

	}
}