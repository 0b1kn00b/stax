package stx.arw;

using stx.Tuples;
import stx.Prelude;
using stx.arw.Arrows;

typedef ArrowApplyT<I,O> = Arrow<Pair<Arrow<I,O>,I>,O>;
class ApplyArrow<I,O> extends Arrow<Pair<Arrow<I,O>,I>,O>{
	public function new(){
		super();
	}
	override inline public function withInput(?i:Pair<Arrow<I,O>,I>,cont : Function1<O,Void>){
		i._1.withInput(
			i._2,
				function(x){
					cont(x);
				}
		);
	}
	static public function app<I,O>(a:Pair<Arrow<I,O>,I>):Future<O>{
		return new ApplyArrow().appFt(a);
	}
	static public function over<I,O>(i:I):Arrow<Arrow<I,O>,O>{
		return 
			function(arrow:Arrow<I,O>){
				return app(Tuples.t2(arrow,i));
			}.arrowOf();
	}
	static public function with<I,O>(a:Arrow<Arrow<I,O>,O>,b:Arrow<Arrow<I,O>,O>,fn:O->O->O):Arrow<Arrow<I,O>,O>{
		return 
			a.split(b).then(fn.spread().lift());
	}
	/**
		wat?
	*/
/*	public function mapI<I2>(f0:I->I2,f1:I2->I){
		return 
			function(arr:Arrow<I,O>,i:I){
				var arr2 	= f1.lift().then(arr);
				var i2 		= f0(i);
				return app( Tuples.t2(arr2,i2) );
			}.spread().arrowOf();
	}*/
}