@:note("#0b1kn00b, Doesn't run unless cont filled in, how to fix?")
class CPSArrow<A,B> implements Arrow<A,B>{
	var cps : A -> RC<Void,B>;

	public function new(cps:A->RC<Void,B>){
		this.cps = cps;
	}
	inline public function withInput(?i:A, cont: Function1<B,Void>):Void{
		cps(i)(cont);
	}
	static public function arrowOf<A,B>(v:A -> RC<Void,B>):Arrow<A,B>{
		return new CPSArrow(v);
	}
}