package stx.arw;

import stx.Prelude;
using stx.Arrow;

@:note("#0b1kn00b, Doesn't run unless cont filled in, how to fix?")
abstract CPSArrow<A,B>(Arrow<A,B>){
	public function new(cps:A->RC<Void,B>){
		this = new Arrow(
			inline function(?i:A, cont: Function1<B,Void>):Void{
			cps(i)(cont);
		});
	}
	public function apply(?i){
		return this.apply(i);
	}
}