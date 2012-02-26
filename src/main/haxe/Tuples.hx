package ;

/**
 * ...
 * @author 0b1kn00b
 */

typedef Tuple2<A,B> = {
	_1 : Null<A>,
	_2 : Null<B>,
}
typedef Tuple3<A,B,C> = { > Tuple2<A,B>,
	_3 : Null<C>,
}
typedef Tuple4<A,B,C,D> = { > Tuple3<A,B,C>,
	_4 : Null<D>,
}
typedef Tuple5<A,B,C,D,E> = { > Tuple4<A,B,C,D>,
	_5 : Null<E>,
}
class Tuples {
	public static inline function t2<A,B>(_1:A,_2:B):Tuple2<A,B>{
		return { _1 : _1, _2 : _2 };
	}
	public static inline function t3<A,B,C>(_1:A,_2:B,_3:C):Tuple3<A,B,C>{
		return { _1 : _1, _2 : _2, _3 : _3};
	}
	public static inline function t4<A,B,C,D>(_1:A,_2:B,_3:C,_4:D):Tuple4<A,B,C,D>{
		return { _1 : _1, _2 : _2, _3 : _3, _4 : _4 };
	}
	public static inline function t5<A,B,C,D,E>(_1:A,_2:B,_3:C,_4:D,_5:E):Tuple5<A,B,C,D,E>{
		return { _1 : _1, _2 : _2, _3 : _3, _4 : _4, _5 : _5 };
	}
}
class T2 {
	public static function first<A,B>(t:Tuple2<A,B>):A{
		return t._1;
	}
	public static function second<A,B>(t:Tuple2<A,B>):B{
		return t._2;
	}
	public static function entuple<A,B>(_1:A,_2:B):Tuple2<A,B>{
		return Tuples.t2(_1, _2);
	}
	public static function apply<A,B,C>(args:Tuple2<A,B>,f:A->B->C):C{
		return f(args._1, args._2);
	}
	public static function call<A,B,C>(f:A->B->C,args:Tuple2<A,B>):C{
		return f(args._1, args._2);
	}
	public static function patch<A,B>(t0:Tuple2<A,B>,t1:Tuple2<A,B>):Tuple2<A,B>{
		var _1 = t1._1 == null ? t0._1 : t1._1;
		var _2 = t1._2 == null ? t0._2 : t1._2;
		return Tuples.t2(_1, _2);
	}
	public static function toArray<A,B>(v:Tuple2<A,B>):Array<Dynamic>{
		return [v._1, v._2];
	}
	public static function fromArray(arr:Array<Dynamic>):Tuple2<Dynamic,Dynamic>{
		return Tuples.t2(arr[0], arr[1]);
	}
}
class T3 {
	public static function entuple<A,B,C>(a:Tuple2<A,B>,c:C):Tuple3<A,B,C>{
		return Tuples.t3(a._1, a._2 , c);
	}
	public static function apply<A,B,C,D>(args:Tuple3<A,B,C>,f:A->B->C->D):D{
		return f(args._1, args._2, args._3);
	}
	public static function call<A,B,C,D>(f:A->B->C->D,args:Tuple3<A,B,C>):D{
		return f(args._1, args._2, args._3);
	}
	public static function patch<A,B,C>(t0:Tuple3<A,B,C>,t1:Tuple3<A,B,C>):Tuple3<A,B,C>{
		var _1 = t1._1 == null ? t0._1 : t1._1;
		var _2 = t1._2 == null ? t0._2 : t1._2;
		var _3 = t1._3 == null ? t0._3 : t1._3;
		return Tuples.t3(_1, _2, _3);
	}
}
class T4 {
	public static function entuple<A,B,C,D>(a:Tuple3<A,B,C>,b:D):Tuple4<A,B,C,D>{
		return Tuples.t4(a._1, a._2, a._3, b);
	}
	public static function call<A,B,C,D,E>(f:A->B->C->D->E,args:Tuple4<A,B,C,D>):E{
		return f(args._1, args._2, args._3, args._4);
	}
	public static function apply<A,B,C,D,E>(args:Tuple4<A,B,C,D>,f:A->B->C->D->E):E{
		return f(args._1, args._2, args._3,args._4);
	}
	public static function patch<A,B,C,D>(t0:Tuple4<A,B,C,D>,t1:Tuple4<A,B,C,D>):Tuple4<A,B,C,D>{
		var _1 = t1._1 == null ? t0._1 : t1._1;
		var _2 = t1._2 == null ? t0._2 : t1._2;
		var _3 = t1._3 == null ? t0._3 : t1._3;
		var _4 = t1._4 == null ? t0._4 : t1._4;
		return Tuples.t4(_1, _2, _3, _4);
	}
}
class T5 {
	public static function entuple<A,B,C,D,E>(a:Tuple4<A,B,C,D>,b:E):Tuple5<A,B,C,D,E>{
		return Tuples.t5(a._1, a._2 , a._3, a._4 ,b);
	}
	public static function call<A,B,C,D,E,F>(f:A->B->C->D->E->F,args:Tuple5<A,B,C,D,E>):F{
		return f(args._1, args._2, args._3, args._4, args._5);
	}	
	public static function apply<A,B,C,D,E,F>(args:Tuple5<A,B,C,D,E>,f:A->B->C->D->E->F):F{
		return f(args._1, args._2, args._3, args._4, args._5);
	}
	public static function patch<A,B,C,D,E>(t0:Tuple5<A,B,C,D,E>,t1:Tuple5<A,B,C,D,E>):Tuple5<A,B,C,D,E>{
		var _1 = t1._1 == null ? t0._1 : t1._1;
		var _2 = t1._2 == null ? t0._2 : t1._2;
		var _3 = t1._3 == null ? t0._3 : t1._3;
		var _4 = t1._4 == null ? t0._4 : t1._4;
		var _5 = t1._5 == null ? t0._5 : t1._5;
		return Tuples.t5(_1, _2, _3, _4, _5);
	}
}