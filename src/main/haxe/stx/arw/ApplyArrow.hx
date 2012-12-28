package stx.arw;

using stx.Tuples;
import stx.Prelude;
using stx.arw.Arrows;

typedef AAIn<I,O> 			= Tuple2<Arrow<I,O>,I>
typedef ArrowApply<I,O> = Arrow<AAIn<I,O>,O>;

class ApplyArrow<I,O> extends Arrow<Tuple2<Arrow<I,O>,I>,O>{
	public function new(){
		super();
	}
	override inline public function withInput(?i:Tuple2<Arrow<I,O>,I>,cont : Function1<O,Void>){
		i._1.withInput(
			i._2,
				function(x){
					cont(x);
				}
		);
	}
	static public function app<I,O>(a:Tuple2<Arrow<I,O>,I>):Future<O>{
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
	static public function mod<A,B,C,D>(a:Arrow<A,Tuple2<Arrow<B,C>,B>>,fn:C->D):Arrow<A,Tuple2<Arrow<B,D>,B>>{
		return 
			a.then(
				function(t:Tuple2<Arrow<B,C>,B>):Tuple2<Arrow<B,D>,B>{
					return t._1.then(fn.lift()).entuple(t._2);
				}.lift()
			);
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