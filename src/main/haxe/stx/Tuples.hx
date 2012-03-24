package stx;

/**
 * ...
 * @author 0b1kn00b
 */
import Prelude;

import stx.plus.Order;
import stx.plus.Equal;
import stx.plus.Show;
import stx.plus.Hasher;

class Tuples {
	
	public static function entuple<A, B>(a: A, b: B): stx.Tuple2<A, B> {
    return new Tuple2(a, b);
  }
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
}
interface Product {
  public var productPrefix (getProductPrefix, null): String;

  public var productArity (getProductArity, null): Int;

  public function productElement(n: Int): Dynamic;
}

class AbstractProduct implements Product {
  public var productPrefix (getProductPrefix, null): String;

  public var productArity (getProductArity, null): Int;

  public var _productElements: Array<Dynamic>;

  public function new(elements: Array<Dynamic>) {
    _productElements = elements;
    _orders = []; _equals = []; _hashes = []; _shows = [];
  }

  public function productElement(n: Int): Dynamic {
    return _productElements[n];
  }

  public function toString(): String {
    var s = productPrefix + "(" + getShow(0)(productElement(0));
    for(i in 1...productArity)
      s += ", " + getShow(i)(productElement(i));
    return s + ")";
  }

  static var _baseHashes = [
    [786433, 24593],
    [196613, 3079, 389],
    [1543, 49157, 196613, 97],
    [12289, 769, 393241, 193, 53]
  ];
  public function hashCode() : Int {
    var h = 0;
    for(i in 0...productArity)
      h += _baseHashes[productArity-2][i] * getHash(i)(productElement(i));
    return h;
  }

  private function productCompare(other : AbstractProduct): Int {
    for(i in 0...productArity) {
      var c = getOrder(i)(productElement(i), other.productElement(i));
      if(c != 0)
        return c;
    }
    return 0;
  }

  private function productEquals(other : AbstractProduct): Bool {
    for(i in 0...productArity)
      if(!getEqual(i)(productElement(i), other.productElement(i)))
        return false;
    return true;
  }

  private function getProductPrefix(): String {
    return Stax.error("Not implemented");
  }

  private function getProductArity(): Int {
    return Stax.error("Not implemented");
  }

  private var _orders : Array<OrderFunction<Dynamic>>;
  private var _equals : Array<EqualFunction<Dynamic>>;
  private var _hashes : Array<HashFunction <Dynamic>>;
  private var _shows  : Array<ShowFunction <Dynamic>>;
  private function getOrder(i : Int) {
    return if(null == _orders[i]) {
      _orders[i] = Order.getOrderFor(productElement(i));
    } else
      _orders[i];
  }

  private function getEqual(i : Int) {
    return if(null == _equals[i]) {
      _equals[i] = Equal.getEqualFor(productElement(i));
    } else
      _equals[i];
  }

  private function getHash(i : Int) {
    return if(null == _hashes[i]) {
      _hashes[i] = Hasher.getHashFor(productElement(i));
    } else
      _hashes[i];
  }

  private function getShow(i : Int) {
    return if(null == _shows[i]) {
      _shows[i] = Show.getShowFor(productElement(i));
    } else
      _shows[i];
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
	public function apply<C>(f : A -> B -> C ) : C
		return f(_1, _2)

		
	public static function first<A, B>(t : Tuple2<A, B>) return t._1
	public static function second<A, B>(t : Tuple2<A, B>) return t._2
	
  override private function getProductPrefix(): String {
    return "stx.Tuple2";
  }

  override private function getProductArity(): Int {
    return 2;
  }

  public function compare(other : stx.Tuple2<A, B>): Int {
    return productCompare(other);
  }

  public function equals(other : stx.Tuple2<A, B>): Bool {
    return productEquals(other);
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
	public function apply<D>(f : A -> B -> C -> D) : D {
		return f(_1, _2, _3);
	}
	public static function entuple<A, B, C, D>(t:stx.Tuple3<A,B,C>,d:D): stx.Tuple4<A, B, C, D> {
    return new Tuple4(t._1, t._2, t._3, d);
  }
	public static function first<A, B>(t : Tuple2<A, B>) return t._1
	public static function second<A, B>(t : Tuple2<A, B>) return t._2
	public static function third<A, B, C>(t : stx.Tuple3<A, B, C>) return t._3
	
  override private function getProductPrefix(): String {
    return "stx.Tuple3";
  }

  override private function getProductArity(): Int {
    return 3;
  }

  public function compare(other : stx.Tuple3<A, B, C>): Int {
    return productCompare(other);
  }

  public function equals(other : stx.Tuple3<A, B, C>): Bool {
    return productEquals(other);
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
	
	public function apply<E>(f : A -> B -> C -> D -> E) : E
		return f(_1, _2, _3, _4)

	public static function first<A, B, C, D>(t : stx.Tuple4<A, B, C, D>) return t._1
	public static function second<A, B, C, D>(t : stx.Tuple4<A, B, C, D>) return t._2
	public static function third<A, B, C, D>(t : stx.Tuple4<A, B, C, D>) return t._3
	public static function fourth<A, B, C, D>(t : stx.Tuple4<A, B, C, D>) return t._4
	
  override private function getProductPrefix(): String {
    return "stx.Tuple4";
  }

  override private function getProductArity(): Int {
    return 4;
  }

  public function entuple<E>(_5: E): stx.Tuple5<A, B, C, D, E> {
    return stx.Tuples.t5(_1, _2, _3, _4, _5);
  }

  public function compare(other : stx.Tuple4<A, B, C, D>): Int {
    return productCompare(other);
  }

  public function equals(other : stx.Tuple4<A, B, C, D>): Bool {
    return productEquals(other);
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

	public function apply<F>(f : A -> B -> C -> D -> E -> F) : F
		return f(_1, _2, _3, _4, _5)
	
	public static function first<A, B, C, D, E>(t : stx.Tuple5<A, B, C, D, E>) return t._1
	public static function second<A, B, C, D, E>(t : stx.Tuple5<A, B, C, D, E>) return t._2
	public static function third<A, B, C, D, E>(t : stx.Tuple5<A, B, C, D, E>) return t._3
	public static function fourth<A, B, C, D, E>(t : stx.Tuple5<A, B, C, D, E>) return t._4
	public static function fifth<A, B, C, D, E>(t : stx.Tuple5<A, B, C, D, E>) return t._5
	
  override private function getProductPrefix(): String {
    return "stx.Tuple5";
  }

  override private function getProductArity(): Int {
    return 5;
  }

  public function compare(other : stx.Tuple5<A, B, C, D, E>): Int {
    return productCompare(other);
  }

  public function equals(other : stx.Tuple5<A, B, C, D, E>): Bool {
    return productEquals(other);
  }/*
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
