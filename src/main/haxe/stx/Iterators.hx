package stx;

import stx.Tuples;
import stx.Tuples;
import Prelude;
using stx.Option;
using Std;

class Iterators {
  @doc("")
  @:noUsing static public inline function create<T>(has:Void->Bool,nxt:Void->T):Iterator<T>{
    return {
      next      : nxt,
      hasNext   : has
    }
  }
  @doc("")
	static public function toArray<T>(itr:Iterator<T>):Array<T>{
		var o = [];
		for(x in itr){
			o.push(x);
		}
		return o;
	}
  @doc("")
	static public function all<T>(itr:Iterator<T>,fn:T->Bool):Bool{
		var ok = true;
		while ( itr.hasNext() ){
			ok = fn( itr.next() );
			if (!ok) break;
		}
		return ok;
	}
  @doc("")
	static public function each<T>(itr:Iterator<T>,fn:T->Void):Iterator<T>{
		for (o in itr){
			fn(o);
		}
		return itr;
	}
  @doc("")
	static public function size<T>(itr:Iterator<T>):Int{
		var o = 0;
		for( i in itr ){
			o++;
		}
		return o;
	}
  @doc("")
	static public function map<T,U>(itr:Iterator<T>, fn:T->U):Iterator<U>{
		var result = [];
		for (v in itr){
			result.push(fn(v));
		}
		return result.iterator();
	}
	static inline public function append<T>(itr0:Iterator<T>,itr1:Iterator<T>):Iterator<T>{
		var result = [];
		for (x in itr0){
			result.push(x);
		}
		for (x in itr1){
			result.push(x);
		}
		return result.iterator();
	}
  @doc("")
	static public function flatMap<T,U>(itr: Iterator<T>, fn:T->Iterator<U>):Iterator<U>{
		var result = [];
		for (x in itr){
			for( y in fn(x) ){
				result.push(y);
			}
		}
		return result.iterator();
	}
  @doc("")
	static public function foldLeft<T, Z>(iter: Iterator<T>, seed: Z, mapper: Z -> T -> Z): Z {
    var folded = seed;
    for (e in iter) { folded = mapper(folded, e); }
    return folded;
  }
  @doc("")
  static public function foldLeft1<T>(iter: Iterator<T>, mapper: T -> T -> T): T {
    var folded = iter.next();
    for (e in iter) { folded = mapper(folded, e); }
    return folded;
  }
  @doc("")
  static public function foldRight<T, Z>(itr: Iterator<T>, z: Z, f: T -> Z -> Z): Z {
  	var a 		= toArray(itr);
    var r 		= z;
    var size 	= a.length;
    for (i in 0...size) { 
      var e = a[size - 1 - i];   
      r = f(e, r);
    }
    return r;
  }
  @doc("")
  static public function zipWith<A,B,C>(itr0:Iterator<A>,itr1:Iterator<B>,fn:A->B->C):Iterator<C>{
    return {
      next : function(){
        return fn(itr0.next(),itr1.next());
      },
      hasNext : function(){
        return itr0.hasNext() && itr1.hasNext();
      }
    };
  }
  static public function zip<A,B>(itr0:Iterator<A>,itr1:Iterator<B>):Iterator<Tuple2<A,B>>{
    return zipWith(itr0,itr1,tuple2);
  }
}
class DirIntIterator {
    var num:Int;
    var step:Int;
    var limit:Int;
    public inline function new(num:Int, limit:Int, step:Int=1):Void {
        this.num = num;
        this.step = step;
        this.limit = limit;
    }
    public inline function next():Int
        return num += step;
    public inline function hasNext():Bool
        return step > 0 ? num + step < limit : num + step > limit;
} 