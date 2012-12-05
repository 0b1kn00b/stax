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
	@:noUsing
	static public function constant<I,O>(v:O):Arrow<I,O>{
		return new FunctionArrow( function(x:I):O {return v;});
	}
	@:noUsing
	static public function pure<I>():Arrow<I,I>{
		return function (x:I):I {
			return x;
		}.lift();
	}
	static public function fan<I,O>(a:Arrow<I,O>):Arrow<I,Pair<O,O>>{
		return 
			a.then(
				function(x){
					return Tuples.t2(x,x);
				}.lift()
			);
	}
	static public function both<A,B>(a:Arrow<A,B>):Arrow<Tuple2<A,A>,Tuple2<B,B>>{
		return a.pair(a);
	}
	static public function as<I,O,NO>(a:Arrow<I,O>,type:Class<NO>):Arrow<I,NO>{
		return a.then( function(x:O):NO { return cast x; }.lift() ); 
	}
	static public function then<I,O,NO>(before:Arrow<I,O>, after:Arrow<O,NO>):Arrow<I,NO> { 
		return new ThenArrow(before, after); 
	}
	static public function pair<A,B,C,D>(pair_:Arrow<A,B>,_pair:Arrow<C,D>):Arrow<Pair<A,C>,Pair<B,D>>{ 
		return new PairArrow(pair_,_pair); 
	}
	static public function first<I,O,I2>(first:Arrow<I,O>):Arrow<Pair<I,I2>,Pair<O,I2>>{
		return new PairArrow(  first , Arrows.pure() );
	}
	static public function second<I,O,I2>(second:Arrow<I,O>):Arrow<Pair<I2,I>,Pair<I2,O>>{
		return new PairArrow( Arrows.pure() , second );
	}

	static public function join<A,B,C>(joinl:Arrow<A,B>,joinr:Arrow<B,C>):Arrow<A,Pair<B,C>>{
		return new ThenArrow( joinl , Arrows.pure().split(joinr) );
	}
	static public function bind<A,B,C>(bindl:Arrow<A,C>,bindr:Arrow<Pair<A,C>,B>):Arrow<A,B>{
		return new ThenArrow( Arrows.pure().split(bindl) , bindr );
	}
	static public function repeat<I,O> (a:Arrow<I,FreeM<I,O>>):Arrow<I,O>{
		return new RepeatArrow(a);
	}
	static public function split<A,B,C>(split_:Arrow<A,B>,_split:Arrow<A,C>):Arrow<A,Pair<B,C>> { 
		return new SplitArrow(split_,_split); 
	}
	static public function or<P1,P2,R0>(or_:Arrow<P1,R0>,_or:Arrow<P2,R0>):Arrow<Either<P1,P2>,R0>{
			return new OrArrow(or_, _or);
	}
	public static function left<B,C,D>(arr:Arrow<B,C>):Arrow<Either<B,D>,Either<C,D>>{
		return new LeftChoiceArrow(arr);
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
	public static function apply<I,O>():Arrow<Pair<Arrow<I,O>,I>,O>{
		return new ApplyArrow();
	}
	@:noUsing
	static public function future<A>():Arrow<Future<A>,A>{
		return new FutureArrow();
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
		return Pair.into.flip().curry()(f).lift();
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