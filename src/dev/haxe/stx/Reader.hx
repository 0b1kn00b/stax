package stx;
import Prelude;

//http://www.youtube.com/watch?v=ZasXwtTRkio
abstract Reader<C,A>(C->A) from C->A to C->A{
  public function new(v){
    this = v;
  }
	@:noUsing static public function unit<C,A>():Reader<C,A>{
		return cast Compose.pure();
	}
	@:noUsing static public function pure<C,A>(a:A):Reader<C,A>{
		return function(c:C){ return a; };
	}
	public function apply(c:C):A{
		return this(c);
	}
}
class Readers{
	static public function apply<C,A>(rdr:Reader<C,A>):A{
		return rdr.apply;
	}
	static public function map<C,A,B>(r:Reader<C,A>,fn:A->B):Reader<C,B>{
		return function(i:C){ return f(r.apply(i)); }
	}
	static public function flatMap<C,A,B>(r:Reader<C,A>,fn:A->B):Reader<C,B>{
		return function(i:C){ return f(apply(i)).apply(i); }
	}
}