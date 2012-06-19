package stx.reactive;

/**
 * Used with permission of Sledorze.
 */
import stx.Prelude;
import stx.Options; 				using stx.Options;
														using stx.reactive.Arrows;
import stx.Tuples; 					using stx.Tuples;
														using stx.Functions;

import stx.test.Assert; using stx.test.Assert;


import sf.event.Event;
import sf.event.EventSystem;


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
	static public function identity<I>():Arrow<I,I>{
		return function (x:I):I {
			return x;
		}.lift();
	}
	static public function fan<I,O>(a:Arrow<I,O>):Arrow<I,Tuple2<O,O>>{
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
	static public function trace<A,B>(a:Arrow<A,B>):Arrow<A,B>{
		var m : Function1<B,B> = function(x:B):B { haxe.Log.trace(x) ; return x;};
		return new Then( a , new FunctionArrow( m ) );
	}
	static public function run<I,O>(a:Arrow<I,O>,?i:I,?cont:O->Void):Void{
		runCPS( a , i , cont == null ? function(x){} : cont );
	}
	public static function apply(){
		return new ArrowApply();
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
		cont.notNull();
				
		var m  = function (reta : O) { this.b.withInput(reta, cont);};
		a.withInput(i, m);
	}
	static public function then<I,O,NO>(before:Arrow<I,O>, after:Arrow<O,NO>):Arrow<I,NO> { 
		return new Then(before, after); 
	}
	static public function join<A,B,C>(joinl:Arrow<A,B>,joinr:Arrow<B,C>):Arrow<A,Tuple2<B,C>>{
		return new Then( joinl , Viaz.identity().split(joinr) );
	}
	static public function bind<A,B,C>(bindl:Arrow<A,C>,bindr:Arrow<Tuple2<A,C>,B>):Arrow<A,B>{
		return new Then( Viaz.identity().split(bindl) , bindr );
	}
}
class FunctionArrow<I,O> implements Arrow<I,O> {
	var f : Function1<I,O>;
	public function new (m : Function<I,O>) { this.f = m;}

	inline public function withInput(?i : I, cont : Function1<O,Void>) : Void { cont(f(i)); }
}
enum RepeatV<RV, DV> {
	Repeat(x:RV);
	Done(x:DV);
}

class RepeatArrow <I, O > implements Arrow < I , O > {
	var a : Arrow < I, RepeatV < I, O > > ;
	public function new < A > (a : Arrow < I, RepeatV < I, O > > ) {
		this.a = a;
	}
	inline public function withInput(?i : I, cont : Function1<O,Void>) : Void {
		var thiz = this;
		function withRes(res : RepeatV < I, O > ) {
			switch (res) {
				case Repeat(rv): thiz.a.withInput(rv, cast withRes#if (flash || js).trampoline()#end); //  break this recursion!
				case Done(dv): cont(dv);
			}
		}
		a.withInput(i, withRes);
	}
	static public function repeat < I, O > (a:Arrow < I, RepeatV < I, O >> ):Arrow<I,O>{
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
			 				case None 		: Done(o);
			 				case Some(v) 	: 
			 					o.push(v);
			 					Repeat( iter );
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
			case Some(v) : Viaz.apply().withInput( a.entuple(v) , Option.Some.andThen(cont));
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
class EventArrow<T:Event> implements Arrow<sf.event.EventSystem<T>,T>{
	var name : String;
	public function new(name:String){
		this.name = name;
	}
	public function withInput(?i : sf.event.EventSystem<T>, cont : Function1<T,Void> ) : Void{
		trace("added: " + name);
		var canceller 	: Void -> Void = null;
		var handler 		= 
			function(evt:T){
				trace("called: " + name);
				canceller();
				cont(cast evt);
			}
		i.addEventListener(name,handler);
		canceller = function(){ i.removeEventListener(name,handler); }
	}
	static public function event<E:Event>(evt:String):Arrow<EventSystem<E>,E>{ 
		return new EventArrow(evt); 
	}
}
class Pair<A,B,C,D> implements Arrow<Tuple2<A,C>,Tuple2<B,D>>{
	public var l 		: Arrow<A,B>;
	public var r 		: Arrow<C,D>;

	public function new(l,r){
		this.l = l;
		this.r = r;
	}
	public function withInput(?i : Tuple2<A,C>, cont : Function1<Tuple2<B,D>,Void> ) : Void{
		cont.notNull();

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
	static public function pair<A,B,C,D>(pair_:Arrow<A,B>,_pair:Arrow<C,D>):Arrow<Tuple2<A,C>,Tuple2<B,D>>{ 
		return new Pair(pair_,_pair); 
	}
	static public function first<I,O,I2>(first:Arrow<I,O>):Arrow<Tuple2<I,I2>,Tuple2<O,I2>>{
		return new Pair(  first , Viaz.identity() );
	}
	static public function second<I,O,I2>(second:Arrow<I,O>):Arrow<Tuple2<I2,I>,Tuple2<I2,O>>{
		return new Pair( Viaz.identity() , second );
	}
}
class Cleave<A,B> implements Arrow<A,Tuple2<B,B>>{
	var a : Arrow<A,B>;
	public function new(a){
		this.a = a;
	}
	//public function withInput(?i : I, cont : Function1<O,Void> ) : Void;
	public function withInput(?i : A, cont : Function1<Tuple2<B,B>,Void> ) : Void{
		//Debug("Split: " + i).log();
		a.withInput( i , 
			function(o){
				cont( Tuples.t2(o,o) );
			}
		);
	}
	static public function cleave<A,B>(a:Arrow<A,B>):Arrow<A,Tuple2<B,B>> {
		return new Cleave(a);
	}
}
class Merge<A,B,C,D> implements Arrow<A,D>{
	var a : Arrow<A,Tuple2<B,C>>;
	var b : Arrow<Tuple2<B,C>,D>;

	public function new(a,b){
		this.a = a;
		this.b = b;
	}
	public function withInput(?i:A,cont:Function1<D,Void>){
		return a.then(b).withInput( i , cont );
	}
	public static function merge<A,B,C,D>(a:Arrow<A,Tuple2<B,C>>,b:Arrow<Tuple2<B,C>,D>):Arrow<A,D>{
		return new Merge(a,b);
	}
}
class Split<A,B,C> implements Arrow<A,Tuple2<B,C>>{
	var a : Pair<A,B,A,C>;
	public function new(l,r){
		this.a = new Pair(l,r);
	}
	public function withInput(?i : A, cont : Function1< Tuple2<B,C> , Void > ) : Void{
		a.withInput( Tuples.t2(i,i) , cont);
	}
	static public function split<A,B,C>(split_:Arrow<A,B>,_split:Arrow<A,C>):Arrow<A,Tuple2<B,C>> { 
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
}
class ArrowApply<I,O> implements Arrow<Tuple2<Arrow<I,O>,I>,O>{

	public function new(){
	}
	public function withInput(?i:Tuple2<Arrow<I,O>,I>,cont : Function1<O,Void>){
		i._1.withInput(
			i._2,
				function(x){
					cont(x);
				}
		);
	}
}
/*
class StateArrow<S,A,B> implements Arrow<A,B>{
	
	var arrow : Tuple2<A,S>,Tuple2<B,S>;
	
	public static function new(a){
		this.arrow = a;
	}
	static public function change<S,B,C>(a1:,f: S -> B -> S) : StateArrow<A,B> { 
		
	}
	public function composeWith<C>(sa:StateArrow<S,B,C>){
		return 
				new StateArrow(
						function(p1:Tuple2<A,S>){
							return this.then(sa);
						}
				)
	}
	//static function composeWithUsing<C,D>(
	static private function merge<S,B,C>(t : Tuple2<Tuple2<S,B>,S>) :Tuple2<S,B>{
		return Tuples.t2(t._2,t._1._2);
	}
	public function access() { }
	public function get() { }
	public function set() { }
	public function next(){ }
}*/
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
		return Tuple2.into.flip().curry()(f).lift();
	}
	static public function run<A,B,C>(arr:Arrow<Tuple2<A,B>,C>,a:A,b:B){
		arr.run( a.entuple(b) );
	}
}
class F3A{
	static public function lift<P1,P2,P3,R>(f:P1->P2->P3->R){
		return Tuple3.into.flip().curry()(f).lift();
	}
	static public function run<A,B,C,D>(arr:Arrow<Tuple3<A,B,C>,D>,a:A,b:B,c:C){
		arr.run( a.entuple(b).entuple(c) );
	}
}
class F4A{
	static public function lift<P1,P2,P3,P4,R>(f:P1->P2->P3->P4->R){
		return Tuple4.into.flip().curry()(f).lift();
	}
	static public function run<A,B,C,D,E>(arr:Arrow<Tuple4<A,B,C,D>,E>,a:A,b:B,c:C,d:D){
		arr.run( a.entuple(b).entuple(c).entuple(d) );
	}
}
class F5A{
	static public function lift<P1,P2,P3,P4,P5,R>(f:P1->P2->P3->P4->P5->R){
		return Tuple5.into.flip().curry()(f).lift();
	}
	static public function run<A,B,C,D,E,F>(arr:Arrow<Tuple5<A,B,C,D,E>,F>,a:A,b:B,c:C,d:D,e:E){
		arr.run( a.entuple(b).entuple(c).entuple(d).entuple(e) );
	}
}