package stx.arw;
class StateArrow{
		static public function write<S,A,B>(a:Arrow<Pair<A,S>,Pair<B,S>>,a1:Arrow<Pair<B,S>,S>):Arrow<Pair<A,S>,Pair<B,S>>{
		return
			a.join( a1 )
			.then(
				function(t:Pair<Pair<B,S>,S>){
					return Tuples.t2(t._1._1,t._2);
				}.lift()
			);
	}
}
class StateArrowImpl<S,A,B> implements Arrow<Pair<A,S>,Pair<B,S>>{

	/*static public function thenUsing<A,B,C,D>(a:Arrow<A,B>,a2:Arrow<C,D>,f:B->Pair<C,B>):Arrow<A,Pair<D,B>>{

	}
	public function composeWith<C>(sa:StateArrow<S,B,C>){
		return 
				new StateArrow(
						function(p1:Pair<A,S>){
							return this.then(sa);
						}.lift()
				);
	}
	*/
	var arrow : Arrow<Pair<A,S>,Pair<B,S>>;
	
	public static function new(a){
		this.arrow = a;
	}
	inline public function withInput(?i:Pair<A,S>,cont:Function<Pair<B,S>,Void>){
		arrow.withInput( i , cont );
	}
	static public function stateA<S,A,B>(a:Arrow<Pair<A,S>,Pair<B,S>>){
		return new StateArrowImpl(a);
	}
	/*
	public function change<B,C>(fn:Function1<Pair<B,S>,S>):StateArrow<S,A,B> { 

	}*/
	public function fetch():Arrow<S,S>{
		return null;
	}
	//static function composeWithUsing<C,D>(
	/*static private function merge<S,B,C>(t : Pair<Pair<S,B>,S>) :Pair<S,B>{
		return Tuples.t2(t._2,t._1._2);
	}*/
	public function access() { }
	public function get() { }
	public function set() { }
	public function next(){ }
}