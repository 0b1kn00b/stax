package stx.reactive;

import haxe.Timer;

import stx.Tuples;										using stx.Tuples;
import stx.Prelude;

import stx.test.TestCase;
import stx.test.Assert;							using stx.test.Assert;

import stx.reactive.Arrows;					using stx.reactive.Arrows;
import stx.Future;										using stx.Future;

typedef State = { };
typedef Transformer<S,A,B> 	= Arrow<Tuple2<S,A>,Tuple2<S,B>>;
typedef StateResult<S,A,B>	= Either<Tuple2<Tuple2<S,A>,Transformer<S,A,B>>,Tuple2<S,B>>;

class ArrowsTest extends TestCase{

	public function new() {
		super();
	}
	public function testCancel() {
		var f = function(x) return x;
		var a = f.lift();
		/**
		 * --
		 * Arrow <State,Tuple2<State,Option<Arrow<State,Dynamic>>>>
		 * state = Arrow <Tuple2<State,A>,Tuple2<State,B>>
		 * command = Arrow<Tuple2<State,A>,Either<Arrow<Tuple2<State,A>,Tuple2<State,B>>,Tuple2<State,C>>
		 */
		var state = { };
		//var a = new StateArrow(deferred.lift()).run( state.entuple(''));
		//deferred.lift().then ( handle.lift() ).run( state.entuple('x') );
	}/*
	public static function handle<S,A,B>(s:StateResult<S,A,B>,cont:Method<Tuple2<S,B>,StateResult<S,A,B>>){
		switch (s) {
			case Left(t)		:
					new StateArrow( t._2.run(t._1).then( cont.lift() ) );
			case Right(v)		:
					cont( v );
		}
	}*/
	/**
	 * changes the state immediately
	 */
	public static function immediate<S,A,B>(t:Tuple2<S,A>):StateResult<S,A,B> {
		var next : B = cast t._2 + 'b';
		return Right(t._1.entuple(next));
	}
	/**
	 * returns an arrow to run 
	 */
	public static function deferred<S,A,B>(t:Tuple2<S,A>):Tuple2<S,B>{
		trace('deferred');
		//var next_command : Transformer<S,A,B> = Viaz.delay(function(x) { trace(x); return cast x; }.lift(), 19);
		var next_command : Transformer<S,A,B> = function(x) { trace(x); return cast x; }.lift();
		return cast t;
	}
}