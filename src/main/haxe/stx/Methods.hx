package stx;

/**
 * ...
 * @author 0b1kn00b
 */
import stx.error.OutOfBoundsError;
import stx.error.AbstractMethodError;

import stx.Prelude;
import stx.Tuples; 											using stx.Tuples;

import haxe.PosInfos;

import haxe.PosInfos;

import stx.Options;											using stx.Options;
import stx.Functions;


import stx.Log;													using stx.Log;
																				using Std;

typedef DynMethod = Method<Dynamic,Dynamic,Dynamic>;

enum MethodConvention {
	Replace;
	Patch;
	Ignore;
}
class Method < I, O, F > {
	public var pos 					: PosInfos;
	public var name 				: String;
	public function setName(n:String):Method<I,O,F>{
		this.name = n;
		return this;
	}
	public var convention 			: MethodConvention;
	
	public var fn 	(default,null) 	: F;
	public var args (default,null) : I;
	public var length (get_length, null) : Int;
	
	private function get_length():Int{
		throw new AbstractMethodError();
		return -1;
	}
	public function new(fn,name:String,?pos:PosInfos){
		this.pos 	= pos;
		this.name 	= name;
		if(fn == null){
			trace("Setting null function".warning()); 
		}
		this.convention = Patch;
		this.fn = fn;
	}
	public function execute(?v:I,?pos:haxe.PosInfos):O{
		if( isEmpty() ) throw new AbstractMethodError();
		return null;
	}
	public function patch(args:I):Method<I,O,F>{
		throw new AbstractMethodError();
		return null;
	}
	public function replaceAt(i:Int,v:Dynamic):Method<I,O,F>{
		throw new AbstractMethodError();
		return null;
	}
	public function equals(m:Method<Dynamic,Dynamic,Dynamic>):Bool {
		//Debug([this,m,this == m]).log();
		return Reflect.compareMethods(this.fn, m.fn);
	}
	public function requals(f:Dynamic){
		return Reflect.compareMethods(this.fn, f);
	}
	public function isEmpty():Bool{
		return fn == null;
	}
	public function toString(){
		return "Method "  + name + "[ " + pos + " ]";
	}
}
class Method0 <O> extends Method<Void,O,Void->O >{
	public function new(fn,name,?pos){
		super(fn,name,pos);
	}
	override public function execute(?v,?pos:PosInfos):O {
		super.execute();
		return fn();
	}
	public static function toMethod<O>(fn:Void->O,name){
		return new Method0(fn,name);
	}
}
class Method1 < I, O > extends Method < I, O, I->O > {
	public function new(fn,name,?pos){
		super(fn,name,pos);
	}
	override private function get_length():Int {
		return 1;
	}
	override public function execute(?v:I,?pos:PosInfos):O {
		if ( fn == null || isEmpty() ){
			throw new AbstractMethodError();
		}
		var o : O = null;
		try{
			 o = switch (convention) {
				case Replace,Patch	: fn(v);
				case Ignore:
					fn(args);
			}
		}catch (e:Dynamic) {
			trace( 'Declared $this \n called $e'.format() );
		}
		//Debug(type(o)).log();
		return o;
	}
	public static function toMethod<I,O>(v:I->O,name,?pos:PosInfos){
		return new Method1(v,name,pos);
	}
	override public function patch(args:I):Method<I,O,I->O>{
		this.args = args;
		return this;
	}
	override public function replaceAt(i:Int, v:Dynamic):Method<I,O,I->O> {
		if (i != 0) {
			throw new OutOfBoundsError();
		}
		this.args = v;
		return this;
	}
}
class Method2<A,B,O> extends Method<Tuple2<A,B>,O,A->B->O>{
	override private function get_length():Int {
		return 2;
	}	
	public function new(fn,name,?pos){
		super(fn,name,pos);
	}
	override public function execute(?v:Tuple2 < A, B >,?pos:PosInfos):O {
		switch (convention) {
			case Patch:
				v = this.args.patch(v);
			case Ignore:
				v = args;
			default :
		}
		return fn(v._1, v._2);
	}
	override public function patch(args:Tuple2<A,B>):Method<Tuple2<A,B>,O,A->B->O>{
		this.args = this.args.patch(args);
		return this;
	}
	override public function replaceAt(i:Int, v:Dynamic):Method<Tuple2<A,B>,O,A->B->O> {
		if (i > 1) {
			throw new OutOfBoundsError();
		}else {
			switch (i) {
				case 0 : untyped args._1 = v;
				case 1 : untyped args._2 = v;
			}
		}
		return this;
	}



	public static function toMethod<A,B,O>(v:A->B->O,name){
		return new Method2(v,name);
	}

	
}
class Method3<A,B,C,O> extends Method<Tuple3<A,B,C>,O,A->B->C->O>{
	override private function get_length():Int {
		return 3;
	}
	public function new(fn,name,?pos){
		super(fn,name,pos);
	}
	override public function execute(?v:Tuple3<A,B,C>,?pos:PosInfos):O{
		switch (convention) {
			case Patch:
				v = args.patch(v);
			case Ignore:
				v = args;
			default :
		}
		return fn(v._1, v._2, v._3);
	}
	override public function patch(args:Tuple3<A,B,C>):Method<Tuple3<A,B,C>,O,A->B->C->O>{
		this.args = this.args.patch(args);
		return this;
	}
	override public function replaceAt(i:Int, v:Dynamic):Method<Tuple3<A,B,C>,O,A->B->C->O> {
		if (i > 2) {
			throw new OutOfBoundsError();
		}else {
			switch (i) {
				case 0 : untyped args._1 = v;
				case 1 : untyped args._2 = v;
				case 2 : untyped args._3 = v;
			}
		}
		return this;
	}

	

	public static function toMethod<A,B,C,O>(v:A->B->C->O,name){
		return new Method3(v,name);
	}
}
class Method4<A,B,C,D,O> extends Method<Tuple4<A,B,C,D>,O,A->B->C->D->O>{
	override private function get_length():Int {
		return 4;
	}
	public function new(fn,name,?pos){
		super(fn,name,pos);
	}
	override public function execute(?v:Tuple4<A,B,C,D>,?pos:PosInfos){
		switch (convention) {
			case Patch:
				v = this.args.patch(v);
			case Ignore:
				v = args;
			default :
		}
		return fn(v._1, v._2, v._3, v._4);
	}
	override public function patch(args:Tuple4<A,B,C,D>):Method<Tuple4<A,B,C,D>,O,A->B->C->D->O>{
		this.args = this.args.patch(args);
		return this;
	}
	override public function replaceAt(i:Int, v:Dynamic):Method<Tuple4<A,B,C,D>,O,A->B->C->D->O> {
		if (i > 3) {
			throw new OutOfBoundsError();
		}else {
			switch (i) {
				case 0 : untyped args._1 = v;
				case 1 : untyped args._2 = v;
				case 2 : untyped args._3 = v;
				case 3 : untyped args._4 = v;
			}
		}
		return this;
	}

	

	public static function toMethod<A,B,C,D,O>(v:A->B->C->D->O,name){
		return new Method4(v,name);
	}
}
class Method5<A,B,C,D,E,O> extends Method<Tuple5<A,B,C,D,E>,O,A->B->C->D->E->O>{
	override private function get_length():Int {
		return 5;
	}
	public function new(fn,name,?pos){
		super(fn,name,pos);
	}
	override public function execute(?v:Tuple5<A,B,C,D,E>,?pos:PosInfos){
		switch (convention) {
			case Patch:
				v = this.args.patch(v);
			case Ignore:
				v = args;
			default :
		}
		return fn(v._1, v._2, v._3, v._4, v._5);
	}
	override public function patch(args	:Tuple5<A,B,C,D,E>):Method<Tuple5<A,B,C,D,E>,O,A->B->C->D->E->O>{
		this.args = this.args.patch(args);		
		return this;
	}
	override public function replaceAt(i:Int, v:Dynamic):Method<Tuple5<A,B,C,D,E>,O,A->B->C->D->E->O> {
		if (i > 4) {
			throw new OutOfBoundsError();
		}else {
			switch (i) {
				case 0 : untyped args._1 = v;
				case 1 : untyped args._2 = v;
				case 2 : untyped args._3 = v;
				case 3 : untyped args._4 = v;
				case 4 : untyped args._5 = v;
			}
		}
		this.args = v;
		return this;
	}

	public static function toMethod<A,B,C,D,E,O>(v:A->B->C->D->E->O,name){
		return new Method5(v,name);
	}
}
class Methods {
	public static function apply<I,O,F>(f:Option<Method<I,O,F>>,v:I,?pos:PosInfos):O{
		return switch (f) {
			case Some(f) : f.execute(v,pos);
			case None : null;
		}
	}
	public static function applyOr<I,O,F>(o:Option<Method<I,O,F>>,x:I,f0:CodeBlock,?pos:PosInfos):Option<O>{
		return switch(o){
			case Some(f) 	: Options.toOption(f.execute(x,pos));
			case None 		: f0(); None;
		}
	}	
}
class Term1{
	public static function toMethod<I>(v:I->Void,name){
		return new Method1(v,name);
	}
}