package stx.arw;

using stx.arw.Arrows;

import stx.Prelude;
import stx.Tuples;
import stx.Eithers;

using stx.Functions;

interface IArrow<I,O>{
	public function withInput(?i : I, cont : Function1<O,Void>) : Void;
}
class Arrow<I,O> implements IArrow<I,O>{
	public function new(){}
	public function withInput(?i : I, cont : Function1<O,Void> ) : Void{}

	static public function act<I>(fn:I->Void):Arrow<I,I>{
		return 
			function(x){
				fn(x);
				return x;
			}.lift();
	}
}

class Arrows{
	/**

	*/
	@:noUsing
	static public function unit<I>():Arrow<I,I>{
		return function (x:I):I {
			return x;
		}.lift();
	}
	/**
	 	x =====> ? -----*-----x
	*/
	@:noUsing
	static public function pure<I,O>(v:O):Arrow<I,O>{
		return new FunctionArrow( function(x:I):O {return v;});
	}
	/**

		a----f----b =====> a-----(f(a),f(a))-----(b,b)

	*/
	static public function fan<I,O>(a:Arrow<I,O>):Arrow<I,Tuple2<O,O>>{
		return 
			a.then(
				function(x){
					return Tuples.t2(x,x);
				}.lift()
			);
	}
	static public function pinch<I,O1,O2>(a:Arrow<Tuple2<I,I>,Tuple2<O1,O2>>):Arrow<I,Tuple2<O1,O2>>{
		return 
			fan(unit()).then(a);
	}
	/**
			                         _____f(a)_____
		a-----f-----b =====>(a,a) /           	 \(b,b)
		                          \_____f(a)_____/
	*/
	static public function both<A,B>(a:Arrow<A,B>):Arrow<Tuple2<A,A>,Tuple2<B,B>>{
		return a.pair(a);
	}
	static public function as<A,B,C>(a:Arrow<A,B>,type:Class<C>):Arrow<A,C>{
		return a.then( function(x:B):C { return cast x; }.lift() ); 
	}
	/**
		(a-----f0-----b,b-----f1-----c) =====> a-----(f1(f0(a)))-----c
	*/
	static public function then<A,B,C>(before:Arrow<A,B>, after:Arrow<B,C>):Arrow<A,C> { 
		return new ThenArrow(before, after); 
	}
	/**         
                                                  _____f0(a)______
		(a-----f0-----b,c-----f1-----d) =====> (a,c) /                \(b,d)
		                                             \_____f1(c)______/
	*/
	static public function pair<A,B,C,D>(pair_:Arrow<A,B>,_pair:Arrow<C,D>):Arrow<Tuple2<A,C>,Tuple2<B,D>>{ 
		return new PairArrow(pair_,_pair); 
	}
	/**
		                            _____f(a)_____
		a-----f-----b =====> (a,c) /              \(b,c)
		                           \______________/
	*/
	static public function first<A,B,C>(first:Arrow<A,B>):Arrow<Tuple2<A,C>,Tuple2<B,C>>{
		return new PairArrow(  first , Arrows.unit() );
	}
	/**
                                 ______________
		a-----f-----b ======> (c,a) /              \(c,b)
                                \_____f(a)_____/
	*/
	static public function second<A,B,C>(second:Arrow<A,B>):Arrow<Tuple2<C,A>,Tuple2<C,B>>{
		return new PairArrow( Arrows.unit() , second );
	}
	/**
                                              ______f0(a)____
		(a-----f0-----b,b-----f1-----c) =====> a /               \(b,c)
                                             \_____f1(f0(a))_/
	*/
	static public function join<A,B,C>(joinl:Arrow<A,B>,joinr:Arrow<B,C>):Arrow<A,Tuple2<B,C>>{
		return new ThenArrow( joinl , Arrows.unit().split(joinr) );
	}
	/**
	                                                      _____f0(a)_____
                                                  _____/_______________\(a,b)__-----f1(a,b)-----c
		(a-----f0-----b,(a,b)-----f1-----c) =====> a /                            /
		                                             \___________________________/

	*/
	static public function bind<A,B,C>(bindl:Arrow<A,B>,bindr:Arrow<Tuple2<A,B>,C>):Arrow<A,C>{
		return new ThenArrow( Arrows.unit().split(bindl) , bindr );
	}
	/**




	*/
	static public function repeat<I,O> (a:Arrow<I,FreeM<I,O>>):Arrow<I,O>{
		return new RepeatArrow(a);
	}
	static public function split<A,B,C>(split_:Arrow<A,B>,_split:Arrow<A,C>):Arrow<A,Tuple2<B,C>> { 
		return new SplitArrow(split_,_split); 
	}
	static public function or<P1,P2,R0>(or_:Arrow<P1,R0>,_or:Arrow<P2,R0>):Arrow<Either<P1,P2>,R0>{
			return new OrArrow(or_, _or);
	}
	public static function left<B,C,D>(arr:Arrow<B,C>):Arrow<Either<B,D>,Either<C,D>>{
		return new LeftChoiceArrow(arr);
	}
	public static function either<A,B>(a:Arrow<A,B>,b:Arrow<A,B>):Arrow<A,B>{
		return new EitherArrow(a,b);
	}
	public static function right<B,C,D>(arr:Arrow<B,C>):Arrow<Either<D,B>,Either<D,C>>{
		return new RightChoiceArrow(arr);
	}
	public static function rout<A,B,C,D>(arr:Arrow<B,Either<C,D>>):Arrow<Either<C,B>,Either<C,D>>{
		return new RightChoiceArrow(arr).then(Eithers.flattenR.lift());
	}
	public static function option<I,O>(a:Arrow<I,O>):Arrow<Option<I>,Option<O>>{
		return new OptionArrow(a);
	}
	static public function printA<A,B>(a:Arrow<A,B>):Arrow<A,B>{
		var m : Function1<B,B> = function(x:B):B { haxe.Log.trace(x) ; return x;};
		return new ThenArrow( a , new FunctionArrow( m ) );
	}
	static public function retCps<O>(a:Arrow<Unit,O>):RC<Void,O>{
		return a.withInput.p1(Unit);
	}
	static public function retFt<O>(a:Arrow<Unit,O>):Future<O>{
		return appFt(a,Unit);
	}
	static public function appCps<I,O>(a:Arrow<I,O>,i:I):RC<Void,O>{
		return a.withInput.p1(i);
	}
	static public function appFt<I,O>(a:Arrow<I,O>,i:I):Future<O>{
		var f = Future.create();
		a.appCps(i)(f.deliver.effectOf());
		return f;
	}
	@:noUsing
	static public function apply<I,O>():Arrow<Tuple2<Arrow<I,O>,I>,O>{
		return new ApplyArrow();
	}
	@:noUsing
	static public function future<A>():Arrow<Future<A>,A>{
		return new FutureArrow();
	}
	static public function arrowOf<I,O>(fn:I->Future<O>):Arrow<I,O>{
		return fn.lift().then( Arrows.future() );
	}
}
class F0A{
	static public function lift<A>(t:Thunk<A>):Arrow<Dynamic,A>{
		return 
		function(v:Dynamic){
			return t();
		}.lift();
	}
}
class F1A{
	static public function lift<P,R>(f:P->R):Arrow<P,R>{
		return new FunctionArrow(f);
	}
}
class F2A{
	static public function lift<P1,P2,R>(f:P1->P2->R){
		return Tuple2.into.flip().curry()(f).lift();
	}
}
class F3A{
	static public function lift<P1,P2,P3,R>(f:P1->P2->P3->R){
		return Tuple3.into.flip().curry()(f).lift();
	}
}
class F4A{
	static public function lift<P1,P2,P3,P4,R>(f:P1->P2->P3->P4->R){
		return Tuple4.into.flip().curry()(f).lift();
	}
}
class F5A{
	static public function lift<P1,P2,P3,P4,P5,R>(f:P1->P2->P3->P4->P5->R){
		return Tuple5.into.flip().curry()(f).lift();
	}
}