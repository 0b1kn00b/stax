package stx.arw;

using stx.arw.Arrows;

import stx.Prelude;
import stx.Tuples;
import stx.Eithers;

using stx.Functions;

abstract Arrow<I,O>(Null<I>->(O->Void)->Void){
  @:noUsing static public function action<I>(fn:I->Void):Arrow<I,I>{
    return Arrows.lift(
      function(x){
        fn(x); return x;
      }
    );
  }
  @:noUsing static public function unit<I>():Arrow<I,I>{
    return Arrows.lift(function(x:I):I {
      return x;
    });
  }
  @:noUsing static public function pure<I,O>(v:O):Arrow<I,O>{
    return Arrows.lift(function(x:I):O {return v;});
  }
  @:noUsing
  static public function future<A>():Arrow<Future<A>,A>{
    return new FutureArrow();
  }
  public function new(v){
    this = v;
  }
  public function rep(){
    return this;
  }
  public function withInput(?i:I,cont:O->Void):Void{
    return (this)(i,cont);
  }
  public inline function apply(?i:I):Future<O>{
    var ft : Future<O> = Future.unit();
      withInput(this,i,ft.deliver.effectOf());
    return ft;
  }
  @:from static public function fromFunction1<I,O>(fn:I->O):Arrow<I,O>{
    return Arrows.lift(fn);
  }
  @:from static public function fromFutureConstructor<I,O>(fn:I->Future<O>):Arrow<I,O>{
    return Arrows.arrowOf(fn);
  }
}
class Arrows{
	static inline public function lift<I,O>(fn:I->O):Arrow<I,O>{
		return new Arrow(
			inline function(?i:I,cont:O->Void){
				cont(fn(i));
			}
		);
	}
	static inline public function arrowOf<I,O>(fn:I->Future<O>){
		return lift(fn).then(Arrow.future());
	}
	static public function first<A,B,C>(first:Arrow<A,B>):Arrow<Tuple2<A,C>,Tuple2<B,C>>{
		return new PairArrow(first, Arrow.unit());
	}
	static public function second<A,B,C>(second:Arrow<A,B>):Arrow<Tuple2<C,A>,Tuple2<C,B>>{
		return new PairArrow(Arrow.unit(), second);
	}
	static public function split<A,B,C>(split_:Arrow<A,B>,_split:Arrow<A,C>):Arrow<A,Tuple2<B,C>> { 
		var a : Arrow<A,Tuple2<B,C>> = new SplitArrow(split_,_split).rep();
		return a;
	}
	static public function pair<A,B,C,D>(pair_:Arrow<A,B>,_pair:Arrow<C,D>):Arrow<Tuple2<A,C>,Tuple2<B,D>>{ 
		return new PairArrow(pair_, _pair); 
	}
	/**

		a----f----b =====> a-----(f(a),f(a))-----(b,b)

	*/
	static public function fan<I,O>(a:Arrow<I,O>):Arrow<I,Tuple2<O,O>>{
		return a.then(
			function(x){
				return Tuples.t2(x,x);
			}.lift()
		);
	}
	static public function pinch<I,O1,O2>(a:Arrow<Tuple2<I,I>,Tuple2<O1,O2>>):Arrow<I,Tuple2<O1,O2>>{
		return fan(Arrow.unit()).then(a);
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
                                              ______f0(a)____
		(a-----f0-----b,b-----f1-----c) =====> a /               \(b,c)
                                             \_____f1(f0(a))_/
	*/
	static public function join<A,B,C>(joinl:Arrow<A,B>,joinr:Arrow<B,C>):Arrow<A,Tuple2<B,C>>{
		return new ThenArrow( joinl , Arrow.unit().split(joinr) );
	}
	/**
	                                                      _____f0(a)_____
                                                  _____/_______________\(a,b)__-----f1(a,b)-----c
		(a-----f0-----b,(a,b)-----f1-----c) =====> a /                            /
		                                             \___________________________/

	*/
	static public function bind<A,B,C>(bindl:Arrow<A,B>,bindr:Arrow<Tuple2<A,B>,C>):Arrow<A,C>{
		return new ThenArrow( Arrow.unit().split(bindl) , bindr );
	}
	/**




	*/
	static public function repeat<I,O> (a:Arrow<I,FreeM<I,O>>):Arrow<I,O>{
		return new RepeatArrow(a);
	}
	static public function or<P1,P2,R0>(or_:Arrow<P1,R0>,_or:Arrow<P2,R0>):Arrow<Either<P1,P2>,R0>{
			return new OrArrow(or_, _or).rep();
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
		return new RightSwitchArrow(arr);
	}
	public static function lout<A,B,C,D>(arr:Arrow<A,Either<C,D>>):Arrow<Either<A,D>,Either<C,D>>{
		return new LeftChoiceArrow(arr).then(Eithers.flattenL.lift());
	}
	public static function option<I,O>(a:Arrow<I,O>):Arrow<Maybe<I>,Maybe<O>>{
		return new MaybeArrow(a);
	}
	static public function printA<A,B>(a:Arrow<A,B>):Arrow<A,B>{
		var m : Function1<B,B> = function(x:B):B { haxe.Log.trace(x) ; return x;};
		return new ThenArrow( a, m.lift() );
	}/*
	static public function retCps<O>(a:Arrow<Unit,O>):RC<Void,O>{
		return a.withInput.bind(Unit);
	}*/
	/*static public function retFt<O>(a:Arrow<Unit,O>):Future<O>{
		return appFt(a,Unit);
	}*/
	/*static public function appCps<I,O>(a:Arrow<I,O>,i:I):RC<Void,O>{
		return a.withInput.bind(i);
	}
	static public function appFt<I,O>(a:Arrow<I,O>,i:I):Future<O>{
		var f = Future.create();
		a.appCps(i)(f.deliver.effectOf());
		return f;
	}
	*/
	@:noUsing
	static public function apply<I,O>():Arrow<Tuple2<Arrow<I,O>,I>,O>{
		return new ApplyArrow();
	}
	@:noUsing
	static public function state<S,A>(a:Arrow<S,Tup2<A,S>>):StateArrow<S,A>{
		return new StateArrow(a);
	}
}
class Arrows0{
	static public function lift<O>(fn:Void->O):Arrow<Unit,O>{
		return Arrows.lift(fn.promote());
	}
}