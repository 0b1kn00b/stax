package stx.ds;

/**
 * ...
 * @author 0b1kn00b
 */
using Type;
using Reflect;

import stx.Prelude;
using stx.Prelude;

using stx.Maths;
using stx.Tuples;
import stx.Functions;
using stx.Arrays;
using stx.Maybes;

using stx.ds.Zipper;

import Map;

class Zipper<T,C> {
	var data 														: T; 
	var path 														: Array<Function1<Dynamic,Dynamic>>;
	public var current( default, null ) : Maybe<C>;
	
	public function new(v:T,?c:C,?p){
		this.data 		= v;
		this.path			= p;
		this.current 	= p == null ? untyped Maybes.create(v) : Maybes.create(c);
		this.path 		= path == null ? [] : path;
	}
	public function root():Zipper<T,T> {
		return new Zipper(data);
	}
	public function down<N>(f:Function1<C,N>):Zipper<T,N>{
		var o : Maybe<N> = current.map(f);
		//if (o == null) { throw "Transform function failed"; }
		return new Zipper( data , o.get() , path.add(f) );
	}
	public function up<P>():Zipper < T, P > {
		var s 		= path.take( path.length - 2 );
		var p : P = cast s.foldl( data , function(value,func):Dynamic { return func(value); } );
		return new Zipper( data , p , s );
	}
	public function get():Maybe<C> {
		return current;
	}
	@noUsing
	public static function create<T>(v:T):Zipper<T,T> {
		return new Zipper(v);
	}
}
class Zippers {
	public static function get<T,C>(z:Zipper<T,C>){
		return z.get();
	}
}
class EnumZipper {
	static public function enumZ<T,C,N>(z:Zipper<T,EnumValue>,index : Int):Zipper<T,N>{
		//Typing hack.
		var n : N 							= Type.enumParameters(z.current)[index];
		var f	: EnumValue -> N 	= function(x) { return Type.enumParameters(x)[index]; }
		return z.down( f );
	}
}
class ObjectZipper {
	public static function field<T,C,N>(z:Zipper<T,C>,field : String):Zipper<T,Tuple2<String,N>>{
		var f	: C -> Tuple2<String,N> 	= function(x:C):Tuple2<String,N> { return Tuples.t2( field , x.field(field) );  };
		return z.down( f );
	}
	static public function objectZ<T,C>(z:Zipper<T,C>):Array<Zipper<T,Tuple2<String,Dynamic>>>{
		var obj = z.get();
		return 
				Reflect.fields(obj).map( z.field );
	}
	static public function fieldsZ<T,C>(za:Array<Zipper<T,Tuple2<String,Dynamic>>>){
		return 
			za.map(
				function(z){
					return z.down( T2.snd );
				}
			);
	}
}
class MapZipper {
	public static function key<T,C>(z:Zipper<T,Map<String,C>>,field : String):Zipper<T,Tuple2<String,C>>{
		var f	: Map<String,C> -> Tuple2<String,C>= function(x:Map<String,C>):Tuple2<String,C> { return Tuples.t2( field , x.get(field) ); };
		return z.down( f );
	}
	static public function hashZ<T,C>(z:Zipper<T,Map<String,C>>):Array<Zipper<T,Tuple2<String,Dynamic>>>{
		return 
				z.get().map( function(obj) return obj.keys().toIterable().toArray().map( z.key ) )
					.getOrElseC([]);
	}
	static public function valuesZ<T,C>(za:Array<Zipper<T,Tuple2<String,C>>>){
		return 
			za.map(
				function(z){
					return z.down( T2.snd );
				}
			);
	}
}
class ArrayZipper {
	public static function index<T,N>(z:Zipper<T,Array<N>>,index:Int):Zipper<T,Tuple2<Int,N>>{
		var f	: Array<N> -> Tuple2<Int,N> 	= function(x:Array<N>):Tuple2<Int,N> { return Tuples.t2(index, x[index]); };
		
		return z.down( f );
	}
	static public function arrayZ<T,C>(z:Zipper<T,Array<C>>):Array<Zipper<T,Tuple2<Int,C>>>{
		trace('b4');
		trace(IntIterators.until(0,2).toArray());
		trace(0.to(1).toArray());
		trace('ar');
		return 
				0.until(z.current.getOrElseC([]).length).toArray().map(z.index);
	}
	static public function elementsZ<T,C>(za:Array<Zipper<T,Tuple2<Int,C>>>){
		return 
			za.map(
				function(z){
					return z.down( T2.snd );
				}
			);
	}
}
class ListZipper{

}