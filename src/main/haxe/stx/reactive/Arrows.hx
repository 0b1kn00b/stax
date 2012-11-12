package stx.reactive;

/**
 * Used with permission of Sledorze.
 */
import stx.Prelude;
import stx.Options; 				using stx.Options;
														using stx.reactive.Arrows;
import stx.Tuples; 					using stx.Tuples;
														using stx.Functions;

import haxe.Timer;
typedef DynArrow = Arrow<Dynamic,Dynamic>;

interface Arrow<I,O>{
	public function withInput(?i : I, cont : Function1<O,Void>) : Void;
}
class Viaz<I,O> implements Arrow<I,O>{
	public function new(){}
	public function withInput(?i : I, cont : Function1<O,Void> ) : Void{}

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
	static public function as<I,O,NO>(a:Arrow<I,O>,type:Class<NO>):Arrow<I,NO>{
		return a.then( function(x:O):NO { return cast x; }.lift() ); 
	}
	static public function runCPS<I,O>(a:Arrow<I,O>,i:I,cont:Function1<O,Void>):Void { return a.withInput(i, cont); }

	static public function runCont<I,O>(a:Arrow<I,O>,i:I):Function1<O,Void>->Void{
		return function (cont:Function1<O,Void>) a.withInput(i, cont);
	}
	static public function runFuture<I,O>(a:Arrow<I,O>,i:I):Future<O>{
		var f : Future<O> = new Future();
		a.runCPS( i, f.deliver.p2(null).toEffect() );
		return f;
	}
	static public function trace<A,B>(a:Arrow<A,B>):Arrow<A,B>{
		var m : Function1<B,B> = function(x:B):B { haxe.Log.trace(x) ; return x;};
		return new Then( a , new FunctionArrow( m ) );
	}
	static public function run<I,O>(a:Arrow<I,O>,?i:I,?cont:O->Void):Void{
		runCPS( a , i , cont == null ? function(x){} : cont );
	}
	static public function execute<I,O>(a:Arrow<I,O>,i:I):Void{
		run(a,i);
	}
	@:noUsing
	public static function applyA<I,O>():Arrow<Pair<Arrow<I,O>,I>,O>{
		return new ArrowApply();
	}
	static public function futureA<A>():Arrow<Future<A>,A>{
		return new FutureArrow();
	}
}

class Stack{
	private var data : Array<Arrow<Dynamic,Dynamic>>;

	public function new(){
		data = [];
	}
	public function next<A,B,C,D,E>(x:A,f:Arrow<B,C>,g:Arrow<D,E>){
		
	}
}
#if !(neko || php || cpp )
class Arrows{
	static public function trampoline<I>(f:I->Void){
		return 
			function(x:I):Void{
				haxe.Timer.delay( 
					function() { 
						f(x);
					},10
				);
			}
	}
}
#end
class Then< I, O, NO > implements Arrow<I, NO> {
	var a : Arrow < I, O >;
	var b : Arrow < O, NO >;
	public function new (a : Arrow < I, O > , b : Arrow < O, NO > ) {
		this.a = a;
		this.b = b;
	}
	inline public function withInput(?i : I, cont : Function1<NO,Void>) : Void {
				
		var m  = function (reta : O) { this.b.withInput(reta, cont);};
		a.withInput(i, m);
	}
	static public function then<I,O,NO>(before:Arrow<I,O>, after:Arrow<O,NO>):Arrow<I,NO> { 
		return new Then(before, after); 
	}
	static public function join<A,B,C>(joinl:Arrow<A,B>,joinr:Arrow<B,C>):Arrow<A,Pair<B,C>>{
		return new Then( joinl , Viaz.pure().split(joinr) );
	}
	static public function bind<A,B,C>(bindl:Arrow<A,C>,bindr:Arrow<Pair<A,C>,B>):Arrow<A,B>{
		return new Then( Viaz.pure().split(bindl) , bindr );
	}
}
class FunctionArrow<I,O> implements Arrow<I,O> {
	var f : Function1<I,O>;
	public function new (m : Function<I,O>) { this.f = m;}

	inline public function withInput(?i : I, cont : Function1<O,Void>) : Void { cont(f(i)); }
}

class RepeatArrow <I, O > implements Arrow < I , O > {
	var a : Arrow < I, Either < I, O > > ;
	public function new < A > (a : Arrow < I, Either < I, O > > ) {
		this.a = a;
	}
	inline public function withInput(?i : I, cont : Function1<O,Void>) : Void {
		var thiz = this;
		function withRes(res : Either < I, O > ) {
			switch (res) {
				case Left(rv): thiz.a.withInput(rv, cast withRes#if (flash || js).trampoline()#end); //  break this recursion!
				case Right(dv): cont(dv);
			}
		}
		a.withInput(i, withRes);
	}
	static public function repeat < I, O > (a:Arrow < I, Either < I, O >> ):Arrow<I,O>{
		return new RepeatArrow(a);
	}
}
class MapArrow <I,O> implements Arrow<Iterable<I>,Iterable<O>>{
	var a : Arrow<I,O>;
	public function new(fn:Arrow<I,O>) {
		this.a = fn;
	}
	inline public function withInput(?i : Iterable<I>, cont : Function1< Iterable<O>, Void > ) {
		trace(i);
		var iter 	= i.iterator();
		var o 		= [];
		var index = 0;
		return 
		 new RepeatArrow(
		 		function(iter){
		 			return iter.hasNext() ? Some( iter.next() ) : None;
		 		}.lift()
		 	.then( a.option() )
		 	.then(
		 		function(x){
		 			return 
			 			switch (x) {
			 				case None 		: Right(o);
			 				case Some(v) 	: 
			 					o.push(v);
			 					Left( iter );
			 			}
		 		}.lift()
		 	 )
		 ).withInput( iter , cont);
	}
	public static function mapper<I,O,P>(a:Arrow<I,O>):Arrow<Iterable<I>,Iterable<O>>{
		return new MapArrow(a);
	}
}
class OptionArrow<I,O> implements Arrow<Option<I>,Option<O>>{
	private var a : Arrow<I,O>;

	public function new(a:Arrow<I,O>){
		this.a = a;
	}
	public function withInput(?i:Option<I>,cont:Function1<Option<O>,Void>){
		switch (i) {
			case Some(v) : Viaz.applyA().withInput( a.entuple(v) , Option.Some.andThen(cont));
			case None 	 : cont(None);
		}
	}
	public static function option<I,O>(a:Arrow<I,O>):Arrow<Option<I>,Option<O>>{
		return new OptionArrow(a);
	}
}
#if !(neko || php || cpp )
class DelayArrow<I,O> implements Arrow<I,O> {
	private var a 			: Arrow <I,O>;
	private var t 			: Int;

	public function new( a : Arrow<I,O> , delay : Int){
		this.a = a;
		this.t = delay;
	}

	public function withInput(?i : I, cont : Function1<O,Void> ) : Void{
		var f = function(){ a.runCPS(i,cont); }
		Timer.delay( f , t );
	}
	static public function delay<I,O>(a:Arrow<I,O>,delay:Int):Arrow<I,O>{return new DelayArrow(a,delay);}
}
#end
#if hxevents
class EventArrow<T> implements Arrow<hxevents.Dispatcher<T>,T>{
	public function new(){

	}
	public function withInput(?i : hxevents.Dispatcher<T>, cont : Function1<T,Void> ) : Void{
		var canceller 	: Void -> Void = null;
		var handler 		= 
			function(evt:T){
				canceller();
				cont(cast evt);
			}
		i.add(handler);
		canceller = function(){ i.remove(handler); }
	}
	static public function eventA<E>():Arrow<hxevents.Dispatcher<E>,E>{ 
		return new EventArrow(); 
	}
}
#end
class PairArrow<A,B,C,D> implements Arrow<Pair<A,C>,Pair<B,D>>{
	public var l 		: Arrow<A,B>;
	public var r 		: Arrow<C,D>;

	public function new(l,r){
		this.l = l;
		this.r = r;
	}
	public function withInput(?i : Pair<A,C>, cont : Function1<Pair<B,D>,Void> ) : Void{

		var ol : Option<B> 	= null;
		var or : Option<D> 	= null;

		var merge 	=
			function(l:B,r:D){
				cont( Tuples.t2(l,r) );
			}
		var check 	=
			function(){
				if (((ol!=null) && (or!=null))){
					merge(ol.get(),or.get());
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
	static public function pair<A,B,C,D>(pair_:Arrow<A,B>,_pair:Arrow<C,D>):Arrow<Pair<A,C>,Pair<B,D>>{ 
		return new PairArrow(pair_,_pair); 
	}
	static public function first<I,O,I2>(first:Arrow<I,O>):Arrow<Pair<I,I2>,Pair<O,I2>>{
		return new PairArrow(  first , Viaz.pure() );
	}
	static public function second<I,O,I2>(second:Arrow<I,O>):Arrow<Pair<I2,I>,Pair<I2,O>>{
		return new PairArrow( Viaz.pure() , second );
	}
}
class Cleave<A,B> implements Arrow<A,Pair<B,B>>{
	var a : Arrow<A,B>;
	public function new(a){
		this.a = a;
	}
	//public function withInput(?i : I, cont : Function1<O,Void> ) : Void;
	public function withInput(?i : A, cont : Function1<Pair<B,B>,Void> ) : Void{
		//Debug("Split: " + i).log();
		a.withInput( i , 
			function(o){
				cont( Tuples.t2(o,o) );
			}
		);
	}
	static public function cleave<A,B>(a:Arrow<A,B>):Arrow<A,Pair<B,B>> {
		return new Cleave(a);
	}
}
class Merge<A,B,C,D> implements Arrow<A,D>{
	var a : Arrow<A,Pair<B,C>>;
	var b : Arrow<Pair<B,C>,D>;

	public function new(a,b){
		this.a = a;
		this.b = b;
	}
	public function withInput(?i:A,cont:Function1<D,Void>){
		return a.then(b).withInput( i , cont );
	}
	public static function merge<A,B,C,D>(a:Arrow<A,Pair<B,C>>,b:Arrow<Pair<B,C>,D>):Arrow<A,D>{
		return new Merge(a,b);
	}
}
class Split<A,B,C> implements Arrow<A,Pair<B,C>>{
	var a : PairArrow<A,B,A,C>;
	public function new(l,r){
		this.a = new PairArrow(l,r);
	}
	public function withInput(?i : A, cont : Function1< Pair<B,C> , Void > ) : Void{
		a.withInput( Tuples.t2(i,i) , cont);
	}
	static public function split<A,B,C>(split_:Arrow<A,B>,_split:Arrow<A,C>):Arrow<A,Pair<B,C>> { 
		return new Split(split_,_split); 
	}
}
class Or< L, R , R0 > implements Arrow < Either < L, R >, R0 > {
	var a : Arrow<L,R0>;
	var b : Arrow<R,R0>;
	
	public function new(l, r) {
		this.a = l;
		this.b = r;
	}
	public function withInput(?i : Either<L,R>, cont : Function1< R0, Void > ) : Void {
		switch (i) {
			case Left(v) 	: a.withInput(v,cont);
			case Right(v)	: b.withInput(v,cont);
		}
	}
	static public function or<P1,P2,R0>(or_:Arrow<P1,R0>,_or:Arrow<P2,R0>):Arrow<Either<P1,P2>,R0>{
			return new Or(or_, _or);
	}
}
class LeftChoice<B,C,D> implements Arrow<Either<B,D>,Either<C,D>>{
	private var a : Arrow<B,C>;

	public function new(a){
		this.a = a;
	}
	public function withInput(?i:Either<B,D>, cont : Function1<Either<C,D>,Void>){
		switch (i) {
			case Left(v) 	:
				new ArrowApply().withInput( Tuples.t2(a,v) ,
					function(x){
						cont( Left(x) );
					}
				);
			case Right(v) :
				cont( Right(v) );
		}
	}
	public static function left<B,C,D>(arr:Arrow<B,C>):Arrow<Either<B,D>,Either<C,D>>{
		return new LeftChoice(arr);
	}
/*	public static function lout<A,B,C,D>(arr:Arrow<A,Either<C,D>>):Arrow<Either<A,B>,Either<C,D>>{
		return new LeftChoice(arr).then(Eithers.flattenL.lift());
	}*/
}
class RightChoice<B,C,D> implements Arrow<Either<D,B>,Either<D,C>>{
	private var a : Arrow<B,C>;
	public function new(a){
		this.a = a;
	}
	public function withInput(?i:Either<D,B>, cont : Function1<Either<D,C>, Void>){
		switch (i) {
			case Right(v) 	:
				new ArrowApply().withInput( Tuples.t2(a,v) ,
					function(x){
						cont( Right(x) );
					}
				);
			case Left(v) :
				cont( Left(v) );
		}
	}
	public static function right<B,C,D>(arr:Arrow<B,C>):Arrow<Either<D,B>,Either<D,C>>{
		return new RightChoice(arr);
	}
	public static function rout<A,B,C,D>(arr:Arrow<B,Either<C,D>>):Arrow<Either<C,B>,Either<C,D>>{
		return new RightChoice(arr).then(Eithers.flattenR.lift());
	}
}
class ArrowApply<I,O> implements Arrow<Pair<Arrow<I,O>,I>,O>{

	public function new(){
	}
	public function withInput(?i:Pair<Arrow<I,O>,I>,cont : Function1<O,Void>){
		i._1.withInput(
			i._2,
				function(x){
					cont(x);
				}
		);
	}
}
#if (neko || cpp || php || java )
import sys.io.Process;
import haxe.io.Input;

class ProcessArrow {

	public static var process : Arrow<Array<String>,Pair<Input,Input>>
		=
			function(a:Array<String>){
				var cmd = a.shift();
				var proc = new Process(cmd,a);
				return Tuples.t2(proc.stderr,proc.stdout);
			}.lift();
}
#end

class FutureArrow<O> implements Arrow<Future<O>,O>{
	public function new(){

	}
	public function withInput(?i:Future<O>,cont:Function<O,Void>){
		i.foreach( cont );
	}
	static public function project<I,O>(fn:I->Future<O>):Arrow<I,O>{
		return fn.lift().then( Viaz.futureA() );
	}
}
class StateArrows{
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
	public function withInput(?i:Pair<A,S>,cont:Function<Pair<B,S>,Void>){
		Viaz.runCPS( arrow, i , cont );
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

#if js
	/*
import js.Dom;
import js.Env;
class JSArrow {

	static public function elementA<I>(name : String) : Arrow<I, HTMLElement> {
		// Env.document.getElementsByName(name)[0];
		return null;
	}
}
*/
#end
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
	static public function thenA<P1,P2,R>(f:P1->P2,a:Arrow<P2,R>):Arrow<P1,R>{
		return lift(f).then(a);
	}
}
class F1F {
	static public function thenF<P1,P2,R>(f1:P1->P2,f2:P2->R){
		var a1 = F1A.lift(f1);
		var a2 = F1A.lift(f2);
		return a1.then(a2);
	}
}
class A1F {
	static public function thenF<P1,P2,R>(a:Arrow<P1,P2>,f:P2->R){
		var a2 = F1A.lift(f);
		return a.then(a2);
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