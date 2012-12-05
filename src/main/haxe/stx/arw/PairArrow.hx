class PairArrow<A,B,C,D> implements Arrow<Pair<A,C>,Pair<B,D>>{
	public var l 		: Arrow<A,B>;
	public var r 		: Arrow<C,D>;

	public function new(l,r){
		this.l = l;
		this.r = r;
	}
	inline public function withInput(?i : Pair<A,C>, cont : Function1<Pair<B,D>,Void> ) : Void{

		var ol : Option<B> 	= null;
		var or : Option<D> 	= null;

		var merge 	=
			function(l:B,r:D){
				cont( Tuples.t2(l,r) );
			}
		var check 	=
			function(){
				if (((ol!=null) && (or!=null))){
					merge(Options.get(ol),Options.get(or));
				}
			}
		var hl 		= 
			function(v:B){
				ol = v == null ? None : Some(v);
				check();
			}
		var hr 		=
			function(v:D){
				or = v == null ? None : Some(v);
				check();
			}
		l.withInput( i._1 , hl );
		r.withInput( i._2 , hr );
	}
}