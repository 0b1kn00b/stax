package stax;

/**
 * ...
 * @author 0b1kn00b
 */
import Prelude;

import stax.plus.Order;
import stax.plus.Equal;
import stax.plus.Show;
import stax.plus.Hasher;

class Tuples {
	public static function entuple<A, B>(_1: A, _2: B): Tuple2<A, B> {
    return Tuple2.create(_1, _2);
  }
	public static inline function t2<A,B>(_1:A,_2:B):Tuple2<A,B>{
		return Tuple2.create(_1, _2);
	}
	public static inline function t3<A,B,C>(_1:A,_2:B,_3:C):Tuple3<A,B,C>{
		return Tuple3.create(_1, _2, _3);
	}
	public static inline function t4<A,B,C,D>(_1:A,_2:B,_3:C,_4:D):Tuple4<A,B,C,D>{
		return Tuple4.create(_1, _2, _3, _4);
	}
	public static inline function t5<A,B,C,D,E>(_1:A,_2:B,_3:C,_4:D,_5:E):Tuple5<A,B,C,D,E>{
		return Tuple5.create(_1, _2, _3, _4, _5);
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

	public function apply<C>(f : A -> B -> C ) : C
		return f(_1, _2)

		
	public static function first<A, B>(t : Tuple2<A, B>) return t._1
	public static function second<A, B>(t : Tuple2<A, B>) return t._2
	
  function new(first: A, second: B) {
    super([first, second]);

    this._1  = first; this._2 = second;
  }

  override private function getProductPrefix(): String {
    return "Tuple2";
  }

  override private function getProductArity(): Int {
    return 2;
  }

  public function compare(other : Tuple2<A, B>): Int {
    return productCompare(other);
  }
	public function entuple<C>(_3: C): Tuple3<A, B, C> {
    return Tuple3.create(_1, _2, _3);
  }	
  public function equals(other : Tuple2<A, B>): Bool {
    return productEquals(other);
  }
	public static function fromType<A,B>(t:TTuple2<A,B>):Tuple2<A,B>{
		return Tuple2.create(t._1, t._2);
	}
	public static function toType<A,B>(t:Tuple2<A,B>):TTuple2<A,B> {
		return { _1 : t._1 , _2 : t._2 };
	}
  public static function create<A, B>(_1: A, _2: B): Tuple2<A, B> {
    return new Tuple2<A, B>(_1, _2);
  }
	public static function patch<A,B>(t0:Tuple2<A,B>,t1:Tuple2<A,B>):Tuple2<A,B>{
		var _1 = t1._1 == null ? t0._1 : t1._1;
		var _2 = t1._2 == null ? t0._2 : t1._2;
		return Tuples.t2(_1, _2);
	}

}
class Tuple3< A, B, C> extends AbstractProduct {
  public var _1 (default, null): A;
  public var _2 (default, null): B;
  public var _3 (default, null): C;

  function new(first: A, second: B, third: C) {
    super([first, second, third]);

    this._1 = first; this._2 = second; this._3 = third;
  }

	public function apply<D>(f : A -> B -> C -> D ) : D
		return f(_1, _2, _3)

	public static function first<A, B, C>(t : Tuple3<A, B, C>) return t._1
	public static function second<A, B, C>(t : Tuple3<A, B, C>) return t._2
	public static function third<A, B, C>(t : Tuple3<A, B, C>) return t._3
	
  override private function getProductPrefix(): String {
    return "Tuple3";
  }

  override private function getProductArity(): Int {
    return 3;
  }

  public function compare(other : Tuple3<A, B, C>): Int {
    return productCompare(other);
  }

  public function equals(other : Tuple3<A, B, C>): Bool {
    return productEquals(other);
  }

  public static function create<A, B, C>(_1: A, _2: B, _3: C): Tuple3<A, B, C> {
    return new Tuple3<A, B, C>(_1, _2, _3);
  }
	public static function patch<A,B,C>(t0:Tuple3<A,B,C>,t1:Tuple3<A,B,C>):Tuple3<A,B,C>{
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

  function new(first: A, second: B, third: C, fourth: D) {
    super([first, second, third, fourth]);

    this._1 = first; this._2 = second; this._3 = third; this._4 = fourth;
  }
	
	public function apply<E>(f : A -> B -> C -> D -> E) : E
		return f(_1, _2, _3, _4)

	public static function first<A, B, C, D>(t : Tuple4<A, B, C, D>) return t._1
	public static function second<A, B, C, D>(t : Tuple4<A, B, C, D>) return t._2
	public static function third<A, B, C, D>(t : Tuple4<A, B, C, D>) return t._3
	public static function fourth<A, B, C, D>(t : Tuple4<A, B, C, D>) return t._4
	
  override private function getProductPrefix(): String {
    return "Tuple4";
  }

  override private function getProductArity(): Int {
    return 4;
  }

  public function entuple<E>(_5: E): Tuple5<A, B, C, D, E> {
    return Tuple5.create(_1, _2, _3, _4, _5);
  }

  public function compare(other : Tuple4<A, B, C, D>): Int {
    return productCompare(other);
  }

  public function equals(other : Tuple4<A, B, C, D>): Bool {
    return productEquals(other);
  }

  public static function create<A, B, C, D>(_1: A, _2: B, _3: C, _4: D): Tuple4<A, B, C, D> {
    return new Tuple4<A, B, C, D>(_1, _2, _3, _4);
  }
	public static function patch<A,B,C,D>(t0:Tuple4<A,B,C,D>,t1:Tuple4<A,B,C,D>):Tuple4<A,B,C,D>{
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

  function new(first: A, second: B, third: C, fourth: D, fifth: E) {
    super([first, second, third, fourth, fifth]);

    this._1 = first; this._2 = second; this._3 = third; this._4 = fourth; this._5 = fifth;
  }

	public function apply<F>(f : A -> B -> C -> D -> E -> F) : F
		return f(_1, _2, _3, _4, _5)
	
	public static function first<A, B, C, D, E>(t : Tuple5<A, B, C, D, E>) return t._1
	public static function second<A, B, C, D, E>(t : Tuple5<A, B, C, D, E>) return t._2
	public static function third<A, B, C, D, E>(t : Tuple5<A, B, C, D, E>) return t._3
	public static function fourth<A, B, C, D, E>(t : Tuple5<A, B, C, D, E>) return t._4
	public static function fifth<A, B, C, D, E>(t : Tuple5<A, B, C, D, E>) return t._5
	
  override private function getProductPrefix(): String {
    return "Tuple5";
  }

  override private function getProductArity(): Int {
    return 5;
  }

  public function compare(other : Tuple5<A, B, C, D, E>): Int {
    return productCompare(other);
  }

  public function equals(other : Tuple5<A, B, C, D, E>): Bool {
    return productEquals(other);
  }

  public static function create<A, B, C, D, E>(_1: A, _2: B, _3: C, _4: D, _5: E): Tuple5<A, B, C, D, E> {
    return new Tuple5<A, B, C, D, E>(_1, _2, _3, _4, _5);
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

typedef TTuple2Dynamic = TTuple2<Dynamic,Dynamic>;
typedef TTuple3Dynamic = TTuple3<Dynamic,Dynamic,Dynamic>;
typedef TTuple4Dynamic = TTuple4<Dynamic,Dynamic,Dynamic,Dynamic>;
typedef TTuple5Dynamic = TTuple5<Dynamic,Dynamic,Dynamic,Dynamic,Dynamic>;

class TTuples {
	public static inline function t2<A,B>(_1:A,_2:B):TTuple2<A,B>{
		return { _1 : _1, _2 : _2 };
	}
	public static inline function t3<A,B,C>(_1:A,_2:B,_3:C):TTuple3<A,B,C>{
		return { _1 : _1, _2 : _2, _3 : _3};
	}
	public static inline function t4<A,B,C,D>(_1:A,_2:B,_3:C,_4:D):TTuple4<A,B,C,D>{
		return { _1 : _1, _2 : _2, _3 : _3, _4 : _4 };
	}
	public static inline function t5<A,B,C,D,E>(_1:A,_2:B,_3:C,_4:D,_5:E):TTuple5<A,B,C,D,E>{
		return { _1 : _1, _2 : _2, _3 : _3, _4 : _4, _5 : _5 };
	}
}
typedef TTuple2<A,B> = {
	_1 : Null<A>,
	_2 : Null<B>,
}
typedef TTuple3<A,B,C> = { > TTuple2<A,B>,
	_3 : Null<C>,
}
typedef TTuple4<A,B,C,D> = { > TTuple3<A,B,C>,
	_4 : Null<D>,
}
typedef TTuple5<A,B,C,D,E> = { > TTuple4<A,B,C,D>,
	_5 : Null<E>,
}
class T2 {
	public static function first<A,B>(t:TTuple2<A,B>):A{
		return t._1;
	}
	public static function second<A,B>(t:TTuple2<A,B>):B{
		return t._2;
	}
	public static function entuple<A,B>(_1:A,_2:B):TTuple2<A,B>{
		return TTuples.t2(_1, _2);
	}
	public static function apply<A,B,C>(args:TTuple2<A,B>,f:A->B->C):C{
		return f(args._1, args._2);
	}
	public static function call<A,B,C>(f:A->B->C,args:TTuple2<A,B>):C{
		return f(args._1, args._2);
	}
	public static function patch<A,B>(t0:TTuple2<A,B>,t1:TTuple2<A,B>):TTuple2<A,B>{
		var _1 = t1._1 == null ? t0._1 : t1._1;
		var _2 = t1._2 == null ? t0._2 : t1._2;
		return TTuples.t2(_1, _2);
	}
	public static function toArray<A,B>(v:TTuple2<A,B>):Array<Dynamic>{
		return [v._1, v._2];
	}
	public static function fromArray(arr:Array<Dynamic>):TTuple2<Dynamic,Dynamic>{
		return TTuples.t2(arr[0], arr[1]);
	}
}
class T3 {
	public static function entuple<A,B,C>(a:TTuple2<A,B>,b:C):TTuple3<A,B,C>{
		return TTuples.t3(a._1, a._2 , b);
	}
	public static function apply<A,B,C,D>(args:TTuple3<A,B,C>,f:A->B->C->D):D{
		return f(args._1, args._2, args._3);
	}
	public static function call<A,B,C,D>(f:A->B->C->D,args:TTuple3<A,B,C>):D{
		return f(args._1, args._2, args._3);
	}
	public static function patch<A,B,C>(t0:TTuple3<A,B,C>,t1:TTuple3<A,B,C>):TTuple3<A,B,C>{
		var _1 = t1._1 == null ? t0._1 : t1._1;
		var _2 = t1._2 == null ? t0._2 : t1._2;
		var _3 = t1._3 == null ? t0._3 : t1._3;
		return TTuples.t3(_1, _2, _3);
	}
}
class T4 {
	public static function entuple<A,B,C,D>(a:TTuple3<A,B,C>,b:D):TTuple4<A,B,C,D>{
		return TTuples.t4(a._1, a._2, a._3, b);
	}
	public static function call<A,B,C,D,E>(f:A->B->C->D->E,args:TTuple4<A,B,C,D>):E{
		return f(args._1, args._2, args._3, args._4);
	}
	public static function apply<A,B,C,D,E>(args:TTuple4<A,B,C,D>,f:A->B->C->D->E):E{
		return f(args._1, args._2, args._3,args._4);
	}
	public static function patch<A,B,C,D>(t0:TTuple4<A,B,C,D>,t1:TTuple4<A,B,C,D>):TTuple4<A,B,C,D>{
		var _1 = t1._1 == null ? t0._1 : t1._1;
		var _2 = t1._2 == null ? t0._2 : t1._2;
		var _3 = t1._3 == null ? t0._3 : t1._3;
		var _4 = t1._4 == null ? t0._4 : t1._4;
		return TTuples.t4(_1, _2, _3, _4);
	}
}
class T5 {
	public static function entuple<A,B,C,D,E>(a:TTuple4<A,B,C,D>,b:E):TTuple5<A,B,C,D,E>{
		return TTuples.t5(a._1, a._2 , a._3, a._4 ,b);
	}
	public static function call<A,B,C,D,E,F>(f:A->B->C->D->E->F,args:TTuple5<A,B,C,D,E>):F{
		return f(args._1, args._2, args._3, args._4, args._5);
	}	
	public static function apply<A,B,C,D,E,F>(args:TTuple5<A,B,C,D,E>,f:A->B->C->D->E->F):F{
		return f(args._1, args._2, args._3, args._4, args._5);
	}
	public static function patch<A,B,C,D,E>(t0:TTuple5<A,B,C,D,E>,t1:TTuple5<A,B,C,D,E>):TTuple5<A,B,C,D,E>{
		var _1 = t1._1 == null ? t0._1 : t1._1;
		var _2 = t1._2 == null ? t0._2 : t1._2;
		var _3 = t1._3 == null ? t0._3 : t1._3;
		var _4 = t1._4 == null ? t0._4 : t1._4;
		var _5 = t1._5 == null ? t0._5 : t1._5;
		return TTuples.t5(_1, _2, _3, _4, _5);
	}
}