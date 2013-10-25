package stx;

import stx.Fail.*;
import stx.err.*;
import stx.Prelude;
import stx.plus.Equal;
import stx.plus.Show;

using stx.Tuples;
using stx.Compare;

typedef KV<V>           = Tuple2<String,V>;

@:noUsing class Tuples {    
    @:noUsing static public inline function t2<A,B>(_1:A,_2:B):stx.Tuple2<A,B>{
        return tuple2(_1, _2);
    }
    @:noUsing static public inline function t3<A,B,C>(_1:A,_2:B,_3:C):stx.Tuple3<A,B,C>{
        return tuple3(_1, _2, _3);
    }
    @:noUsing static public inline function t4<A,B,C,D>(_1:A,_2:B,_3:C,_4:D):stx.Tuple4<A,B,C,D>{
        return tuple4(_1, _2, _3, _4);
    }
    @:noUsing static public inline function t5<A,B,C,D,E>(_1:A,_2:B,_3:C,_4:D,_5:E):stx.Tuple5<A,B,C,D,E>{
        return tuple5(_1, _2, _3, _4, _5);
    }
}
abstract Product(Array<Dynamic>) to Array<Dynamic>{
  public function new(v){
    this = v;
  }
  @:from public static function fromTuple1<T1>(a:Tuple1<T1>):Product{
    return switch (a) {
      case tuple1(a) : new Product([a]);
    }
  }
  @:from public static function fromTuple2<T1,T2>(v:Tuple2<T1,T2>):Product{
    return switch (v) {
      case tuple2(a,b) : new Product([a,b]);
    }
  }
  @:from public static function fromTuple3<T1,T2,T3>(v:Tuple3<T1,T2,T3>):Product{
    return switch (v) {
      case tuple3(a,b,c) : new Product([a,b,c]);
    }
  }
  @:from public static function fromTuple4<T1,T2,T3,T4>(v:Tuple4<T1,T2,T3,T4>):Product{
    return switch (v) {
      case tuple4(a,b,c,d) : new Product([a,b,c,d]);
    }
  }
  @:from public static function fromTuple5<T1,T2,T3,T4,T5>(v:Tuple5<T1,T2,T3,T4,T5>):Product{
    return switch (v) {
      case tuple5(a,b,c,d,e) : new Product([a,b,c,d,e]);
    }
  }
  public function elements(){
    return this;
  }
  public function element(n:Int){
    return this[n];
  }
  public var length(get,never):Int;
  public function get_length():Int{
    return this.length;
  }
}
enum Tuple1<T1> {
    tuple1(t1 : T1);
}
class Tuples1 {
    public static function fst<T1>(tuple : Tuple1<T1>) : T1 {
        return switch (tuple){
            case tuple1(a)      : a;
        }
    }
    public static function equals<T1>(a : Tuple1<T1>, b : Tuple1<T1>) : Bool {
        return switch (a) {
            case tuple1(t1_0):
                switch (b) {
                    case tuple1(t1fst): Equal.getEqualFor(t1_0)(t1_0,t1fst);
                }
        }
    }
    public static function toString<T1>(tuple : Tuple1<T1>) : String {
        return '${Show.show(fst(tuple))}';
    }
    public static function toArray<T1>(tuple : Tuple1<T1>) : Array<Dynamic> {
        return switch (tuple){
            case tuple1(a)    : [a];
        }
    }
    public static function toProduct<T1>(tp:Tuple1<T1>) : Product{
        return new Product(toArray(tp));
    }
}
enum Tuple2<T1, T2> {
    tuple2(t1 : T1, t2 : T2);
}
class Tuples2 {
    public static function fst<T1, T2>(tuple : Tuple2<T1, T2>) : T1 {
        return switch (tuple){
            case tuple2(a,_)    : a;
        }
    }
    public static function snd<T1, T2>(tuple : Tuple2<T1, T2>) : T2 {
        return switch (tuple){
            case tuple2(_,b)    : b;
        }
    }
    public static function swap<T1, T2>(tuple : Tuple2<T1, T2>) : Tuple2<T2, T1> {
        return switch (tuple) {
            case tuple2(a, b): tuple2(b, a);
        }
    }
    public static function equals<T1, T2>(  a : Tuple2<T1, T2>,
                                            b : Tuple2<T1, T2>
                                            ) : Bool {
        return switch (a) { 
            case tuple2(t1_0, t2_0):
                switch (b) {
                    case tuple2(t1fst, t2fst): Equal.getEqualFor(t1_0)(t1_0,t1fst) && Equal.getEqualFor(t2_0)(t2_0,t2fst);
                }
        }
    }
    public static function toString<T1, T2>(tuple : Tuple2<T1, T2>) : String {
        return '${Show.show(fst(tuple))}${Show.show(snd(tuple))}';
    }
    public static function toArray<T1, T2>(tuple : Tuple2<T1, T2>) : Array<Dynamic> {
        return switch (tuple){
            case tuple2(a,b)    : [a,b];
        }
    }
    public static function toProduct<T1,T2>(tp:Tuple2<T1,T2>) : Product{
        return new Product(toArray(tp));
    }
    public inline static function entuple<A, B, C>(t:Tuple2<A,B>,c:C): Tuple3<A, B, C> {
        return tuple3(t.fst(), t.snd(), c);
    }
    public static function into<A,B,C>(t:Tuple2<A,B>,f:A->B->C):C {
        return switch(t){
            case tuple2(a,b)    : f(a,b);
        }
    }
    public inline static function tupled<A,B,C>(f : A -> B -> C){
        return into.bind(_,f);
    }
}
typedef Pair<A> = Tuple2<A,A>;

class Pairs{
  static public function bothOrOtherWith<A,B>(tp:Pair<A>,red:Reducer<A>):A{
    return 
      tp.fst() == null ? tp.snd() : red(tp.fst(),tp.snd());
  }
}
enum Tuple3<T1, T2, T3> {
    tuple3(t1 : T1, t2 : T2, t3 : T3);
}
class Tuples3 {
    public static function fst<T1, T2, T3>(tuple : Tuple3<T1, T2, T3>) : T1 {
        return switch (tuple){
            case tuple3(a,_,_)  : a;
        }
    }
    public static function snd<T1, T2, T3>(tuple : Tuple3<T1, T2, T3>) : T2 {
        return switch (tuple){
            case tuple3(_,b,_)  : b;
        }
    }
    public static function thd<T1, T2, T3>(tuple : Tuple3<T1, T2, T3>) : T3 {
        return switch (tuple){
            case tuple3(_,_,c)  : c;
        }
    }
    public static function equals<T1, T2, T3>(    a : Tuple3<T1, T2, T3>,
                                                b : Tuple3<T1, T2, T3>
                                                ) : Bool {
        return switch (a) {
            case tuple3(t1_0, t2_0, t3_0):
                switch (b) {
                    case tuple3(t1fst, t2fst, t3fst):
                        Equal.getEqualFor(t1_0)(t1_0,t1fst) && Equal.getEqualFor(t2_0)(t2_0,t2fst) &&
                            Equal.getEqualFor(t3_0)(t3_0,t3fst);
                }
        }
    }
    public static function toString<T1, T2, T3>(tuple : Tuple3<T1, T2, T3>) : String {
        return '${Show.show(fst(tuple))}${Show.show(snd(tuple))}${Show.show(thd(tuple))}';
    }
    public static function toArray<T1, T2, T3>(tuple : Tuple3<T1, T2, T3>) : Array<Dynamic> {
        return switch (tuple){
            case tuple3(a,b,c)      : [a,b,c];
        }
    }
    public static function toProduct<T1,T2,T3>(tp:Tuple3<T1,T2,T3>) : Product{
        return new Product(toArray(tp));
    }
    static public function entuple<A, B, C, D>(t:stx.Tuple3<A,B,C>,d:D): stx.Tuple4<A, B, C, D> {
        return tuple4(t.fst(), t.snd(), t.thd(), d);
    }
    static public function into<A,B,C,D>(t:Tuple3<A,B,C>,f : A -> B -> C -> D):D{
        return switch (t){
            case tuple3(a,b,c)  : f(a,b,c);
        }
    }
    static public function tupled<A,B,C,D>(fn:A->B->C->D){
      return into.bind(_,fn);
    }
}
enum Tuple4<T1, T2, T3, T4> {
    tuple4(t1 : T1, t2 : T2, t3 : T3, t4 : T4);
}
class Tuples4 {
    public static function fst<T1, T2, T3, T4>(tuple : Tuple4<T1, T2, T3, T4>) : T1 {
        return switch (tuple){
            case tuple4(a,_,_,_)    : a;
        }
    }
    public static function snd<T1, T2, T3, T4>(tuple : Tuple4<T1, T2, T3, T4>) : T2 {
        return switch (tuple){
            case tuple4(_,b,_,_)    : b;
        }
    }
    public static function thd<T1, T2, T3, T4>(tuple : Tuple4<T1, T2, T3, T4>) : T3 {
        return switch (tuple){
            case tuple4(_,_,c,_)    : c;
        }
    }
    public static function frt<T1, T2, T3, T4>(tuple : Tuple4<T1, T2, T3, T4>) : T4 {
        return switch (tuple){
            case tuple4(_,_,_,d)    : d;
        }
    }
    public static function equals<T1, T2, T3, T4>(    a : Tuple4<T1, T2, T3, T4>,
                                                    b : Tuple4<T1, T2, T3, T4>
                                                    ) : Bool {
        return switch (a) {
            case tuple4(t1_0, t2_0, t3_0, t4_0):
                switch (b) {
                    case tuple4(t1fst, t2fst, t3fst, t4fst):
                        Equal.getEqualFor(t1_0)(t1_0,t1fst) && Equal.getEqualFor(t2_0)(t2_0,t2fst) &&
                            Equal.getEqualFor(t3_0)(t3_0,t3fst) && Equal.getEqualFor(t4_0)(t4_0,t4fst);
                }
        }
    }
    public static function toString<T1,T2,T3,T4>(tuple : Tuple4<T1,T2,T3,T4>) : String {
        return '${Show.show(fst(tuple))}${Show.show(snd(tuple))}${Show.show(thd(tuple))}${Show.show(frt(tuple))}';
    }
    public static function toArray<T1,T2,T3,T4>(tuple : Tuple4<T1,T2,T3,T4>) : Array<Dynamic> {
        return switch (tuple){
            case tuple4(a,b,c,d)    : [a,b,c,d];
        }
    }
    public static function toProduct<T1,T2,T3,T4>(tp:Tuple4<T1,T2,T3,T4>) : Product{
        return new Product(toArray(tp));
    }
    static public function entuple<A,B,C,D,E>(tp:Tuple4<A,B,C,D>,e:E):stx.Tuple5<A,B,C,D,E>{
        return stx.Tuples.t5(tp.fst(), tp.snd(), tp.thd(), tp.frt(), e);
    }
    static public function into<A,B,C,D,E>(t:Tuple4<A,B,C,D>,f : A -> B -> C -> D -> E) : E {
        return switch (t){
            case tuple4(a,b,c,d)    : f(a,b,c,d);
        }
    }
    static public function tupled<A,B,C,D,E>(f : A -> B -> C -> D -> E){
        return into.bind(_,f);
    }
}
enum Tuple5<T1, T2, T3, T4, T5> {
    tuple5(t1 : T1, t2 : T2, t3 : T3, t4 : T4, t5 : T5);
}
class Tuples5 {
    public static function fst<T1, T2, T3, T4, T5>(tuple : Tuple5<T1, T2, T3, T4, T5>) : T1 {
        return switch (tuple){
            case tuple5(a,_,_,_,_)  : a;
        }
    }
    public static function snd<T1, T2, T3, T4, T5>(tuple : Tuple5<T1, T2, T3, T4, T5>) : T2 {
        return switch (tuple){
            case tuple5(_,b,_,_,_)  : b;
        }
    }
    public static function thd<T1, T2, T3, T4, T5>(tuple : Tuple5<T1, T2, T3, T4, T5>) : T3 {
        return switch (tuple){
            case tuple5(_,_,c,_,_)  : c;
        }
    }
    public static function frt<T1, T2, T3, T4, T5>(tuple : Tuple5<T1, T2, T3, T4, T5>) : T4 {
        return switch (tuple){
            case tuple5(_,_,_,d,_)  : d;
        }
    }
    public static function fth<T1, T2, T3, T4, T5>(tuple : Tuple5<T1, T2, T3, T4, T5>) : T5 {
        return switch (tuple){
            case tuple5(_,_,_,_,e)  : e;
        }
    }
    public static function equals<T1, T2, T3, T4, T5>(    a : Tuple5<T1, T2, T3, T4, T5>,
                                                        b : Tuple5<T1, T2, T3, T4, T5>
                                                        ) : Bool {
        return switch (a) {
            case tuple5(t1_0, t2_0, t3_0, t4_0, t5_0):
                switch (b) {
                    case tuple5(t1fst, t2fst, t3fst, t4fst, t5fst):
                        Equal.getEqualFor(t1_0)(t1_0,t1fst) && Equal.getEqualFor(t2_0)(t2_0,t2fst) &&
                            Equal.getEqualFor(t3_0)(t3_0,t3fst) && Equal.getEqualFor(t4_0)(t4_0,t4fst) &&
                                Equal.getEqualFor(t5_0)(t5_0,t5fst);
                }
        }
    }
    public static function toString<T1, T2, T3, T4, T5>(tuple : Tuple5<T1, T2, T3, T4, T5>) : String {
        return '${Show.show(fst(tuple))}${Show.show(snd(tuple))}${Show.show(thd(tuple))}${Show.show(frt(tuple))}${Show.show(fth(tuple))}';
    }
    public static function toArray<T1, T2, T3, T4, T5>(tuple : Tuple5<T1, T2, T3, T4, T5>) : Array<Dynamic> {
        return switch (tuple){
            case tuple5(a,b,c,d,e)  : [a,b,c,d,e];
        }
    }
    public static function toProduct<T1,T2,T3,T4,T5>(tp:Tuple5<T1,T2,T3,T4,T5>) : Product{
        return new Product(toArray(tp));
    }
    static public function into<A,B,C,D,E,F>(t:Tuple5<A,B,C,D,E>,f : A -> B -> C -> D -> E -> F) : F {
        return switch (t){
            case tuple5(a,b,c,d,e)  : f(a,b,c,d,e);
        }
    }
    static public function tupled<A,B,C,D,E,F>(f : A -> B -> C -> D -> E -> F){
        return into.bind(_,f);
    }
}
