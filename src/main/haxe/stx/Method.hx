package stx;

import stx.Prelude;
import stx.Tuples.*;

using stx.Tuples;

@nb('#0b1kn00b: lots and lots of allocation is the problem')
abstract Method<A,B>(A->B) from A->B to A->B{
	public function new(v:A->B){
		this = v;
	}
	@:from static public inline function fromFunction2<A,B,C>(f:A->B->C):Method<Tup2<A,B>,C>{
		return T2.spread(f);
	}
	@:from static public inline function fromFunction3<A,B,C,D>(f:A->B->C->D):Method<Tup3<A,B,C>,D>{
		return T3.spread(f);	
	}
	@:from static public inline function fromFunction4<A,B,C,D,E>(f:A->B->C->D->E):Method<Tup4<A,B,C,D>,E>{
		return T4.spread(f);		
	}
	@:from static public inline function fromFunction5<A,B,C,D,E,F>(f:A->B->C->D->E->F):Method<Tup5<A,B,C,D,E>,F>{
		return T5.spread(f);			
	}
	@:noUsing static public inline function unit<A>():Method<A,A>{
		return cast function(x) return x;
	}
	public function apply(v:A):B{
		return (this)(v);
	}
	public function then<C>(f:Method<B,C>):Method<A,C>{
		return function(a:A):C{
			return f.apply(apply(this,a));
		}
	}
	public function first<C>():Method<Tup2<A,C>,Tup2<B,C>>{
		return function(t:Tuple2<A,C>){
      return tuple2(apply(this,t.fst()),t.snd());
    }
	}
	public function second<C>():Method<Tup2<C,A>,Tup2<C,B>>{
		return function(t:Tuple2<C,A>){
      return tuple2(t.fst(),apply(this,t.snd()));
    }
	}
	public function left<C>():Method<Either<A,C>,Either<B,C>>{
    return function(e:Either<A,C>):Either<B,C>{
      return switch (e) {
        case Left(v)  : Left(apply(this,v));
        case Right(v) : Right(v);
      }
    }
	}
	public function right<C,D>():Method<Either<C,A>,Either<C,B>>{
		return function(e:Either<C,A>):Either<C,B>{
			return switch (e) {
        case Left(v)  : Left(v);
        case Right(v) : Right(apply(this,v));
      }
  	}
	}
	public function bind<C>(bindr:Tuple2<A,B>->C):Method<A,C> {
		return unit().split(this).then( bindr );
	}
	public function split<C>(_split:A->C):Method<A,Tuple2<B,C>>{ 
    return function(x:A){
      return tuple2(apply(this,x),_split(x));
    }
  }
	public function pair<C,D>(fn2:Method<C,D>) {
		return function(t){
      return tuple2(apply(this,t.fst()),fn2.apply(t.snd()));
    }
	}
}