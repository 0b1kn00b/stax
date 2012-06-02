package stx.reactive;

/**
 * Used with permission of Sledorze.
 */
import Prelude;
import stx.Options;using stx.Options;
import stx.reactive.Arrows;using stx.reactive.Arrows;
import stx.Tuples; using stx.Tuples;
import stx.Methods;using stx.Methods;
import stx.test.Assert; using stx.test.Assert;

#if flash
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.events.EventDispatcher;
#end


import haxe.Timer;
typedef DynArrow = Arrow<Dynamic,Dynamic>;

interface Arrow<I,O>{
	public function withInput(?i : I, cont : Method<O,Void,O->Void>) : Void;
}
class Viaz<I,O> implements Arrow<I,O>{
	public function new(){}
	public function withInput(?i : I, cont : Method<O,Void,O->Void> ) : Void{}

	static public function constant<I,O>(v:O):Arrow<I,O>{
		return new FunctionArrow( new Method1 ( function(x:I):O {return v;} , 'constant' ) );
	}
	static public function identity<I>():Arrow<I,I>{
		return function (x:I):I {
			return x;
		}.lift();
	}
	static public function first<I,O>(first:Arrow<I,O>):Arrow<Tuple2<I,I>,Tuple2<O,I>>{
		return new Pair(  first , Viaz.identity() );
	}
	static public function second<I,O>(second:Arrow<I,O>):Arrow<Tuple2<I,I>,Tuple2<I,O>>{
		return new Pair( Viaz.identity() , second );
	}
	//a0:Arrow<A,C>,a1:Arrow<Tuple2<A,C>,B>
	static public function bind<A,B,C>(bindl:Arrow<A,C>,bindr:Arrow<Tuple2<A,C>,B>):Arrow<A,B>{
		return new ThenArrow( Viaz.identity().split(bindl) , bindr );
	}
	//a0:Arrow<AP,A0R>,a1:Arrow<A0R,A1R>
	//Tuple2<A0R,A1R>
	//static public function join<A,B,C>(joinl:Arrow<A,C>,joinr:Arrow<Tuple2<A,C>,B>):Arrow<A,B>{
//		return new ThenArrow( joinl , Viaz.identity().split(joinr) );
//	}
	static public function as<I,O,NO>(a:Arrow<I,O>,type:Class<NO>):Arrow<I,NO>{
		return a.then( function(x:O):NO { return cast x; }.toMethod('cast').lift() ); 
	}
	static public function then<I,O,NO>(before:Arrow<I,O>, after:Arrow<O,NO>):Arrow<I,NO> { return new ThenArrow(before, after); }
	static public function lift<I,O>(lift:Method<I,O,I->O>):Arrow<I,O>{ return new FunctionArrow(lift); }
	static public function pair<A,B,C,D>(pair_:Arrow<A,B>,_pair:Arrow<C,D>):Arrow<Tuple2<A,C>,Tuple2<B,D>>{ return new Pair(pair_,_pair); }
	static public function repeat < I, O > (a:Arrow < I, RepeatV < I, O >> ):Arrow<I,O>{return new RepeatArrow(a);}
	#if !(neko || php)
	static public function delay<I,O>(a:Arrow<I,O>,delay:Int):Arrow<I,O>{return new DelayArrow(a,delay);}
	#end
	static public function split<A,B,C>(split_:Arrow<A,B>,_split:Arrow<A,C>):Arrow<A,Tuple2<B,C>> { return new Split(split_,_split
	); }
	#if flash
	static public function event(evt:String):Arrow<IEventDispatcher,Event>{ return new EventArrow(evt); }
	#end
	static public function or<P1,P2,R0>(or_:Arrow<P1,R0>,_or:Arrow<P2,R0>):Arrow<Either<P1,P2>,R0>
	{
			return new Or(or_, _or);
	}
	static public function future<I>(future:Future<I>):Arrow < Future<I>, I > { return new FutureArrow(); }
	static public function runCPS<I,O>(a:Arrow<I,O>,i:I,cont:Method<O,Void,O->Void>):Void { return a.withInput(i, cont); }

	static public function runCont<I,O>(a:Arrow<I,O>,i:I,cont:Method<O,Void,O->Void>):Method<O,Void,O->Void>->Void{
		return function (cont:Method<O,Void,O->Void>) a.withInput(i, cont);
	}
	static public function trace<A,B>(a:Arrow<A,B>):Arrow<A,B>{
		var m : Method<B,B,B->B> = new Method1( function(x:B):B { haxe.Log.trace(x) ; return x;}, 'trace' ); 
		return new ThenArrow( a , new FunctionArrow( m ) );
	}
	static public function run<I,O>(a:Arrow<I,O>,?i:I,?cont:Method<O,Void,O->Void>):Void{
		var c = cont == null ?  new Method1(function(x){},'terminal') : cont;
		runCPS( a , i , c );
	}
	static public function promise() {
		return new PromiseArrow();
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
			}.toMethod('trampoline');
	}
}
#end
class ThenArrow< I, O, NO > implements Arrow<I, NO> {
	var a : Arrow < I, O >;
	var b : Arrow < O, NO >;
	public function new (a : Arrow < I, O > , b : Arrow < O, NO > ) {
		this.a = a;
		this.b = b;
	}

	inline public function withInput(?i : I, cont : Method<NO,Void,NO->Void>) : Void {
		cont.notNull();
				
		var m  = function (reta : O) { this.b.withInput(reta, cont);}.toMethod('then');
		a.withInput(i, m);
	}
}
class FunctionArrow<I,O> implements Arrow<I,O> {
	var m : Method<I,O,I->O>;
	public function new (m : Method<I,O,I->O>) { this.m = m;}

	inline public function withInput(?i : I, cont : Method<O,Void,O->Void>) : Void { cont.execute(m.execute(i)); }
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
	inline public function withInput(?i : I, cont : Method<O,Void,O->Void>) : Void {
		var thiz = this;
		function withRes(res : RepeatV < I, O > ) {
			switch (res) {
				case Repeat(rv): thiz.a.withInput(rv, cast withRes#if (flash || js).trampoline()#end); //  break this recursion!
				case Done(dv): cont.execute(dv);
			}
		}
		a.withInput(i, withRes.toMethod('repeat'));
	}
}
/*class MapArrow <I,O> implements Arrow<Iterable<I>,O>{
	var method : Method1<I,O,I -> O>;
	public function new(fn) {
		this.method = fn.toMethod('map');
	}
	inline public function withInput(?i : I, cont : Method < O, Void, O->Void > ) {
		
	}
}*/
#if !(neko || php || cpp )
class DelayArrow<I,O> implements Arrow<I,O> {
	private var a 			: Arrow <I,O>;
	private var delay 	: Int;

	public function new( a : Arrow<I,O> , delay : Int){
		this.a = a;
		this.delay = delay;
	}

	public function withInput(?i : I, cont : Method<O,Void,O->Void> ) : Void{
		var f = function(){ a.run(i,cont); }
		Timer.delay( f , delay );
	}
}
#end
#if flash
class EventArrow<Event> implements Arrow<flash.events.IEventDispatcher,Event>{
	var name : String;
	public function new(name:String){
		this.name = name;
	}
	public function withInput(?i : flash.events.IEventDispatcher, cont : Method<Event,Void,Event->Void> ) : Void{
		//trace("added: " + name);
		var canceller 	: Void -> Void = null;
		var handler 		= 
			function(evt:Event){
				//trace("called: " + name);
				canceller();
				cont.execute(evt);
			}
		i.addEventListener(name,handler);
		canceller = function(){ i.removeEventListener(name,handler); }
	}
}
#end
class Pair<A,B,C,D> implements Arrow<Tuple2<A,C>,Tuple2<B,D>>{
	public var l 		: Arrow<A,B>;
	public var r 		: Arrow<C,D>;

	public function new(l,r){
		this.l = l;
		this.r = r;
	}
	public function withInput(?i : Tuple2<A,C>, cont : Method<Tuple2<B,D>,Void,Tuple2<B,D>->Void> ) : Void{
		cont.notNull();

		var ol : Option<B> 	= null;
		var or : Option<D> 	= null;

		var merge 	=
			function(l:B,r:D){
				cont.execute( Tuples.t2(l,r) );
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
		l.withInput( i._1 , hl.toMethod('left') );
		r.withInput( i._2 , hr.toMethod('right'));
	}
}
class Split<A,B,C> implements Arrow<A,Tuple2<B,C>>{
	var a : Pair<A,B,A,C>;
	public function new(l,r){
		this.a = new Pair(l,r);
	}
	//public function withInput(?i : I, cont : Method<O,Void,O->Void> ) : Void;
	public function withInput(?i : A, cont : Method< Tuple2<B,C> , Void , Tuple2<B,C> ->Void > ) : Void{
		//Debug("Split: " + i).log();
		a.withInput( Tuples.t2(i,i) , cont);
	}
}
class Or< L, R , R0 > implements Arrow < Either < L, R >, R0 > {
	var a : Arrow<L,R0>;
	var b : Arrow<R,R0>;
	
	public function new(l, r) {
		this.a = l;
		this.b = r;
	}
	public function withInput(?i : Either<L,R>, cont : Method < R0, Void, R0->Void > ) : Void {
		switch (i) {
			case Left(v) 	: a.withInput(v,cont);
			case Right(v)	: b.withInput(v,cont);
		}
	}
}
class FutureArrow<I> implements Arrow<Future<I>,I>{
	public function new() {
		
	}
	public function withInput(?i : Future<I>, cont : Method < I, Void, I->Void > ) : Void {
		i.deliverTo(
				function(p1:I) {
					cont.execute(p1);
				}
		);
	}
}
class PromiseArrow<I,E> implements Arrow<Promise<Dynamic,I>,I>{
	public function new() {
		
	}
	public function withInput(?i : Promise<Dynamic,I>, cont : Method < I, Void, I->Void > ) : Void {
		i.foreach(
				function(p1:I) {
					cont.execute(p1);
				}
		);
	}
}
class ArrowApply {
	
}
/*
class PromiseArrow < L, R, R0 > implements Arrow < Promise< L, R > , R0 > {
	public function new() {
		
	}
	public function withInput(?i : Promise<L,R>, cont : Method < R0, Void, R0->Void > ) : Void {
		i.resolve(
				function(p1:Either<L,R>) {
					cont.execute(p1);
				}
		);
	}
}
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
class M0A {
	static public function lift<R>(m:Method0<R>):Arrow<Void,R>{
		return Viaz.lift(cast m);
	}
}

class M0F {
	static public function lift<R>(f:Void->R):Arrow<Void,R>{
		return f.toMethod('anonymous').lift();
	}
}
class M1A{
	static public function lift<P,R>(m:Method1<P,R>):Arrow<P,R>{
		return Viaz.lift(m);
	}
}
class F1A{
	static public function lift<P,R>(f:P->R):Arrow<P,R>{
		return f.toMethod('anonymous').lift();
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
class M2A{
	static public function lift<P1,P2,R>(m:Method2<P1,P2,R>){
		return new stx.reactive.FunctionArrow(cast m);
	}
}
class F2A{
	static public function lift<P1,P2,R>(f:P1->P2->R){
		return f.toMethod('anonymous').lift();
	}
}
class M3A{
	static public function lift<P1,P2,P3,R>(m:Method3<P1,P2,P3,R>){
		return Viaz.lift(cast m);
	}
}
class F3A{
	static public function lift<P1,P2,P3,R>(f:P1->P2->P3->R){
		return f.toMethod('anonymous').lift();
	}
}
class M4A{
	static public function lift<P1,P2,P3,P4,R>(m:Method4<P1,P2,P3,P4,R>){
		return Viaz.lift(cast m);
	}
}
class F4A{
	static public function lift<P1,P2,P3,P4,R>(f:P1->P2->P3->P4->R){
		return f.toMethod('anonymous').lift();
	}
}
class M5A{
	static public function lift<P1,P2,P3,P4,P5,R>(m:Method5<P1,P2,P3,P4,P5,R>){
		return Viaz.lift(cast m);
	}
}
class F5A{
	static public function lift<P1,P2,P3,P4,P5,R>(f:P1->P2->P3->P4->P5->R){
		return f.toMethod('anonymous').lift();
	}

}