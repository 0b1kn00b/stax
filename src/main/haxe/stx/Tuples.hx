package stx;

/**
 * ...
 * @author 0b1kn00b
 */
import stx.Prelude;
using Stax;
                    using stx.Tuples;  

class Tuples {
	
	public static inline function t2<A,B>(_1:A,_2:B):stx.Tuple2<A,B>{
		return new Tuple2(_1, _2);
	}
	public static inline function t3<A,B,C>(_1:A,_2:B,_3:C):stx.Tuple3<A,B,C>{
		return new Tuple3(_1, _2, _3);
	}
	public static inline function t4<A,B,C,D>(_1:A,_2:B,_3:C,_4:D):stx.Tuple4<A,B,C,D>{
		return new Tuple4(_1, _2, _3, _4);
	}
	public static inline function t5<A,B,C,D,E>(_1:A,_2:B,_3:C,_4:D,_5:E):stx.Tuple5<A,B,C,D,E>{
		return new Tuple5(_1, _2, _3, _4, _5);
	}
  public static inline function elements(p:Product){
    return p.elements();
  }
}
interface Product {
  public var prefix(get_prefix, null): String;

  public var length(get_length,null) : Int;

  public function element(n: Int): Dynamic;
  public function elements():Array<Dynamic>;

  public function flatten():Array<Dynamic>;
}

class AbstractProduct implements Product {
	@:note('0b1kn00b', 'As these values are used and set privately, the chances of error are slight')
	private var tools : Array<Function1<Dynamic,Dynamic>>;
	
  public var prefix (get_prefix, null): String;

  public var length(get_length, null): Int;

  public var _elements: Array<Dynamic>;

  public function new(elements: Array<Dynamic>) {
    _elements = elements;
  }

  public function element(n: Int): Dynamic {
    return _elements[n];
  }

  public function toString(): String {
    var s = prefix + "(" + stx.ds.plus.Show.getShowFor(element(0))(element(0));
    for(i in 1...length)
      s += ", " + stx.ds.plus.Show.getShowFor(element(i))(element(i));
    return s + ")";
  }
  private function get_prefix(): String {
    return Stax.error("Not implemented");
  }

  private function get_length(): Int {
    return Stax.error("Not implemented");
  }
  
  public function elements():Array<Dynamic> {
    return switch (length) {
      case 5  : 
          var p : Tuple5<Dynamic,Dynamic,Dynamic,Dynamic,Dynamic> = cast(this);
          [ p._1 , p._2 , p._3 , p._4, p._5 ];
      case 4  :
          var p : Tuple4<Dynamic,Dynamic,Dynamic,Dynamic> = cast(this);
          [ p._1 , p._2 , p._3 , p._4 ];
      case 3  :
          var p : Tuple3<Dynamic,Dynamic,Dynamic> = cast(this);
          [ p._1 , p._2 , p._3 ];
      case 2  :
          var p : Tuple2<Dynamic,Dynamic> = cast(this);
          [ p._1 , p._2 ];
    }
  }
  public function flatten():Array<Dynamic>{
    var flatn : Product -> Array<Dynamic> = null;

    flatn = function(p:Product){
          return 
            p.elements().flatMap(
              function(v){
                return if( Std.is(v,Product) ){
                   flatn(v).flatMap(  Stax.identity() );
                }else{
                  [v];
                }
              }
            );
        }
    return flatn(this);
  }
}
class Tuple2<A, B> extends AbstractProduct {
  public var _1 (default, null): A;
  public var _2 (default, null): B;

	public function new (_1:A, _2:B) {
		this._1 = _1;
		this._2 = _2;
		super([_1,_2]);
	}
	public static function entuple<A, B, C>(t:stx.Tuple2<A,B>,c:C): stx.Tuple3<A, B, C> {
    return new Tuple3(t._1, t._2, c);
  }
	public static function into<A,B,C>(t:Tuple2<A,B>, f : A -> B -> C ) : C
		return f(t._1, t._2)

		
	public static function first<A, B>(t : Tuple2<A, B>) return t._1
	public static function second<A, B>(t : Tuple2<A, B>) return t._2
	
  public static function map<A,B,C,D>(t:Tuple2<A,B>,f1: A -> C, f2: B -> D):Tuple2<C,D>{
    return f1(t._1).entuple(f2(t._2));
  }
  override private function get_prefix(): String {
    return "stx.Tuple2";
  }

  override private function get_length(): Int {
    return 2;
  }

/*  public static function create<A, B>(_1: A, _2: B): stx.Tuple2<A, B> {
    return new stx.Tuple2<A, B>(_1, _2);
  }*/
	public static function patch<A,B>(t0:stx.Tuple2<A,B>,t1:stx.Tuple2<A,B>):stx.Tuple2<A,B>{
		var _1 = t1._1 == null ? t0._1 : t1._1;
		var _2 = t1._2 == null ? t0._2 : t1._2;
		return Tuples.t2(_1, _2);
	}
}
class Tuple3<A, B, C> extends AbstractProduct {
  public var _1 (default, null) : A;
  public var _2 (default, null) : B;
	public var _3	(default, null) : C;
	
	public function new (_1:A, _2:B, _3:C) {
		this._1 = _1;
		this._2 = _2;
		this._3 = _3;
		super([_1, _2, _3]);
	}
	public static function into<A,B,C,D>(t:Tuple3<A,B,C>,f : A -> B -> C -> D) : D {
		return f(t._1, t._2, t._3);
	}
  public static function map<A,B,C,D,E,F>(t:Tuple3<A,B,C>,f1: A -> D, f2: B -> E, f3 : C -> F):Tuple3<D,E,F>{
    return f1(t._1).entuple(f2(t._2)).entuple(f3(t._3));
  }
	public static function entuple<A, B, C, D>(t:stx.Tuple3<A,B,C>,d:D): stx.Tuple4<A, B, C, D> {
    return new Tuple4(t._1, t._2, t._3, d);
  }
	public static function first<A, B>(t : Tuple2<A, B>) return t._1
	public static function second<A, B>(t : Tuple2<A, B>) return t._2
	public static function third<A, B, C>(t : stx.Tuple3<A, B, C>) return t._3
	
  override private function get_prefix(): String {
    return "stx.Tuple3";
  }

  override private function get_length(): Int {
    return 3;
  }
/*
  public static function create<A, B, C>(_1: A, _2: B, _3: C): stx.Tuple3<A, B, C> {
    return new stx.Tuple3<A, B, C>(_1, _2, _3);
  }*/
	public static function patch<A,B,C>(t0:stx.Tuple3<A,B,C>,t1:stx.Tuple3<A,B,C>):stx.Tuple3<A,B,C>{
		var _1 = t1._1 == null ? t0._1 : t1._1;
		var _2 = t1._2 == null ? t0._2 : t1._2;
		var _3 = t1._3 == null ? t0._3 : t1._3;
		return Tuples.t3(_1, _2, _3);
	}
}
class Tuple4< A, B, C, D> extends AbstractProduct {
  public var _1 (default, null): A;
  public var _2 (default, null): B;
  public var _3 (default, null): C;
  public var _4 (default, null): D;

  public function new(first: A, second: B, third: C, fourth: D) {
    super([first, second, third, fourth]);

    this._1 = first; this._2 = second; this._3 = third; this._4 = fourth;
  }
	
	public static function into<A,B,C,D,E>(t:Tuple4<A,B,C,D>,f : A -> B -> C -> D -> E) : E
		return f(t._1, t._2, t._3, t._4)

	public static function first<A, B, C, D>(t : stx.Tuple4<A, B, C, D>) return t._1
	public static function second<A, B, C, D>(t : stx.Tuple4<A, B, C, D>) return t._2
	public static function third<A, B, C, D>(t : stx.Tuple4<A, B, C, D>) return t._3
	public static function fourth<A, B, C, D>(t : stx.Tuple4<A, B, C, D>) return t._4
	
  override private function get_prefix(): String {
    return "stx.Tuple4";
  }

  override private function get_length	(): Int {
    return 4;
  }

  public function entuple<E>(_5: E): stx.Tuple5<A, B, C, D, E> {
    return stx.Tuples.t5(_1, _2, _3, _4, _5);
  }

 /* public static function create<A, B, C, D>(_1: A, _2: B, _3: C, _4: D): stx.Tuple4<A, B, C, D> {
    return new Tuple4<A, B, C, D>(_1, _2, _3, _4);
  }*/
	public static function patch<A,B,C,D>(t0:stx.Tuple4<A,B,C,D>,t1:stx.Tuple4<A,B,C,D>):stx.Tuple4<A,B,C,D>{
		var _1 = t1._1 == null ? t0._1 : t1._1;
		var _2 = t1._2 == null ? t0._2 : t1._2;
		var _3 = t1._3 == null ? t0._3 : t1._3;
		var _4 = t1._4 == null ? t0._4 : t1._4;
		return Tuples.t4(_1, _2, _3, _4);
	}
}

class Tuple5< A, B, C, D, E> extends AbstractProduct {
  public var _1 (default, null): A;
  public var _2 (default, null): B;
  public var _3 (default, null): C;
  public var _4 (default, null): D;
  public var _5 (default, null): E;

  public function new(first: A, second: B, third: C, fourth: D, fifth: E) {
    super([first, second, third, fourth, fifth]);

    this._1 = first; this._2 = second; this._3 = third; this._4 = fourth; this._5 = fifth;
  }

	public static function into<A,B,C,D,E,F>(t:Tuple5<A,B,C,D,E>,f : A -> B -> C -> D -> E -> F) : F
		return f(t._1, t._2, t._3, t._4, t._5)
	
	public static function first<A, B, C, D, E>(t : stx.Tuple5<A, B, C, D, E>) return t._1
	public static function second<A, B, C, D, E>(t : stx.Tuple5<A, B, C, D, E>) return t._2
	public static function third<A, B, C, D, E>(t : stx.Tuple5<A, B, C, D, E>) return t._3
	public static function fourth<A, B, C, D, E>(t : stx.Tuple5<A, B, C, D, E>) return t._4
	public static function fifth<A, B, C, D, E>(t : stx.Tuple5<A, B, C, D, E>) return t._5
	
  override public function get_prefix(): String {
    return "stx.Tuple5";
  }

  override private function get_length(): Int {
    return 5;
  }
  /*
  public static function create<A, B, C, D, E>(_1: A, _2: B, _3: C, _4: D, _5: E): stx.Tuple5<A, B, C, D, E> {
    return new Tuple5<A, B, C, D, E>(_1, _2, _3, _4, _5);
  }*/
	public static function patch<A,B,C,D,E>(t0:stx.Tuple5<A,B,C,D,E>,t1:stx.Tuple5<A,B,C,D,E>):stx.Tuple5<A,B,C,D,E>{
		var _1 = t1._1 == null ? t0._1 : t1._1;
		var _2 = t1._2 == null ? t0._2 : t1._2;
		var _3 = t1._3 == null ? t0._3 : t1._3;
		var _4 = t1._4 == null ? t0._4 : t1._4;
		var _5 = t1._5 == null ? t0._5 : t1._5;
		return Tuples.t5(_1, _2, _3, _4, _5);
	}
}
class Entuple{
  public static function entuple<A, B>(a: A, b: B): stx.Tuple2<A, B> {
    return new Tuple2(a, b);
  }
}