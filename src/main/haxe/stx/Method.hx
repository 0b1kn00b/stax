package stx;

import Prelude;
import stx.Tuples;

using stx.Tuples;
using stx.Compose;

@doc("
  Unified function Type (up to arity 5) using Tuples.
")
abstract Method<A,B>(A->B) from A->B to A->B{
	public function new(v:A->B){
		this = v;
	}
  @:from static public inline function fromFunction1<A,B,C>(f:A->B):Method<A,B>{
    return new Method(function(x:A):B return f(x));
  }
	@:from static public inline function fromFunction2<A,B,C>(f:A->B->C):Method<Tuple2<A,B>,C>{
		return Tuples2.tupled(f);
	}
	@:from static public inline function fromFunction3<A,B,C,D>(f:A->B->C->D):Method<Tuple3<A,B,C>,D>{
		return Tuples3.tupled(f);	
	}
	@:from static public inline function fromFunction4<A,B,C,D,E>(f:A->B->C->D->E):Method<Tuple4<A,B,C,D>,E>{
		return Tuples4.tupled(f);		
	}
	@:from static public inline function fromFunction5<A,B,C,D,E,F>(f:A->B->C->D->E->F):Method<Tuple5<A,B,C,D,E>,F>{
		return Tuples5.tupled(f);			
	}
	@:noUsing static public inline function unit<A>():Method<A,A>{
		return cast function(x) return x;
	}
	public function apply(v:A):B{
		return (this)(v);
	}
  public function call(args:Array<Dynamic>){
    var arg : Dynamic = switch (args.length) {
      case 5  : tuple5(args[0],args[1],args[2],args[3],args[4]);
      case 4  : tuple4(args[0],args[1],args[2],args[3]);
      case 3  : tuple3(args[0],args[1],args[2]);
      case 2  : tuple2(args[0],args[1]);
      case 1  : args[0];
      default : throw ('args length unhandled: is ${args.length} ');
    }
    return apply(arg);
  }
	public function then<C>(f:Method<B,C>):Method<A,C>{
		return function(a:A):C{
      var out = apply(this,a);
      return f.apply(out);
		}
	}
	public function first<C>():Method<Tuple2<A,C>,Tuple2<B,C>>{
		return function(t:Tuple2<A,C>){
      return tuple2(apply(this,t.fst()),t.snd());
    }
	}
	public function second<C>():Method<Tuple2<C,A>,Tuple2<C,B>>{
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
	public function tie<C>(bindr:Tuple2<A,B>->C):Method<A,C> {
		return unit().split(this).then( bindr );
	}
	public function split<C>(_split:A->C):Method<A,Tuple2<B,C>>{ 
    var m : Method<A,C> = _split;
    return function(x:A):Tuple2<B,C>{
      var l = apply(this,x);
      var r = m.apply(x);
      return tuple2(l,r);
    }
  }
	public function pair<C,D>(fn2:C -> D) {
		return function(t){
      return tuple2(apply(this,t.fst()),fn2(t.snd()));
    }
	}
}