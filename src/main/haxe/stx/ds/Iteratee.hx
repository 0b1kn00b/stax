package stx.ds;
using stx.reactive.Reactive;
using stx.Functions;
import stx.ds.LList;
using stx.ds.Iteratee;

enum Input<E> {
	El(e: E);
	Empty();
	EOF;
}
typedef TEnumerator<E,A> ={
	apply : Iteratee<E,A> -> Future<Iteratee<E,A>>
}
class Enumerator<E,A>{
	public function new(){

	}
	public dynamic function apply(i:Iteratee<E,A>):Future<Iteratee<E,A>>{
		return null;
	}
}
class Enumerators{
	static inline function fromIterable(){
		/*return 
		new Enumerator(
			{
				apply : 
					function(i:Iteratee<E,A>):Promise<Iteratee<E,A>>{

					}
			}
		);*/
	}	
	 /*private def enumerateSeq[E, A]: (Seq[E], Iteratee[E, A]) => Promise[Iteratee[E, A]] = { (l, i) =>
    l.foldLeft(Promise.pure(i))((i, e) =>
      i.flatMap(it => it.pureFold{ 
        case Step.Cont(k) => k(Input.El(e))
        case _ => it
      }))
  }*/
}
typedef FIteratee<E,A>  = Input<E> -> Iteratee<E, A>;

enum Step<E,A> {
  Done(a:A, remaining:Input<E>);
  Cont(k: FIteratee<E,A>);
  Error(msg:String, input:Input<E>);
}
typedef TIteratee<E,A,B> = {
	state 		: Step<E,A>,
	?fold 		: (Step<E,A>->Future<B>)->Future<B>
}
class Iteratee<E,A>{
	public static function iterateeOf<E,A>(s:Step<E,A>){
		return new Iteratee( { state : s } );
	}
	public function new(?v:TIteratee<E,A,Dynamic>){
		if (v.fold!=null) this.fold = v.fold;
		this.state = v.state;
	}
	public var state(default,null):Step<E,A>;

	public dynamic function fold<B>(folder: Step<E,A>->Future<B>):Future<B>{
		return folder(state);
	}
	public function run():Future<A>{
		return
			switch(state){
				case Step.Done(a,_) 	: Future.pure(a);
				case Step.Cont(k)  	:
					k(Input.EOF).fold(
						function(x){
							return switch (x) {
								case Step.Done(a1,_) 		: Future.pure(a1);
								case Step.Cont(_) 			: throw("diverging iteratee after Input.EOF");null;
								case Step.Error(msg,e) 	: throw(msg);null;
							}
						}
					);
				case Step.Error(msg,e) :
					throw(msg);null;
			}
	}
	public function fold1<B>(
		done 	:	A -> Input<E> -> Future<B>,
		cont 	: (Input<E> -> Iteratee<E,A>) -> Future<B>,
		err  	: String -> Input<E> -> Future<B>
		)
	{
		return 
			fold(
				function(x){
					return switch(x){
						case Step.Done(a,e) 			: done(a,e);
						case Step.Cont(k) 				: cont(k);
						case Step.Error(msg,e) 		: err(msg,e);
					}
				}
			);
	}
	public function pureFold<B>(folder:Step<E,A>->B):Future<B>{
		return 
			fold(
				function(s){
					return Future.pure(folder(s));
				}
			);
	}
}
class Iteratees{
	static public function folds<E,A,B>(it:Iteratee<E,A>,folder:(Step<E,A>->Future<B>)):Future<B>{
		return it.fold(folder);
	}
	static public function flatten<E,A,B>(it:Iteratee<E,A>,i:Future<Iteratee<E,A>>):Iteratee<E,B>{
		return new Iteratee(
			cast{
				fold 		: 
					function(folder:Step<E,A>->Future<B>):Future<B>{
						return i.flatMap(folds.p2(folder));
					},
				state 	: it.state
			}
		);
	}
	/*
	static public function fold<E,A>(state:A):(A->E->A)->Iteratee<E,A>{
		return 
			function(f:A -> E -> A){
				var step : A -> (Input<E> -> Iteratee<E,A>) = null;
				step = function(s:A): Input<E> -> Iteratee<E,A>{
					return 
						function(i:Input<E>):Iteratee<E,A>{
							return
								 switch(i){
								 		case EOF 		: Iteratee.Done(s,EOF);
								 		case Empty 	: 
									 		Iteratee.Cont(
									 			function(i){
									 				return step(s)(i);
									 			}
									 		);
									 	case El(e) 	:
									 		var s1 = f(s,e);
									 		Iteratee.Cont(
									 			function(i){
									 				return step(s1)(i);
									 			}
									 		);
								 }
						}
				}
				return
				Iteratee.Cont(
					function(i:Input<E>):Iteratee<E,A>{
						return step(state)(i);
					}
				);
			}
	}
	static public function foldStep<A,B,E>(
		done 	:	A -> Input<E> -> Future<B>,
		cont 	: Input<E> -> Iteratee<E,A> -> Future<B>,
		err  	: String -> Input<E> -> Future<B>
		)
	{
		return 
			fold(
				function(x){
					return switch(x){
						case Step.Done(a,e) 			: done(a,e);
						case Step.Cont(k) 				: cont(k);
						case Step.Error(msg,e) 		: err(msg,e);
					}
				}
			);
	}
    /*
	static public function doneFold(done:A->Input<E>
	def fold1a[B](done: (A, Input[E]) => Promise[B],
    cont: (Input[E] => Iteratee[E, A]) => Promise[B],
    error: (String, Input[E]) => Promise[B]): Promise[B] = fold({
      case Step.Done(a,e) => done(a,e)
      case Step.Cont(k) => cont(k)
      case Step.Error(msg,e) => error(msg,e)
    })
    
	static public function fold1<E,A,B>(state:A){
		return 
			function(f:A->E->Future<A>){
				var step = null;
				step = 
					function(s:A){
						function(i:Input<E>){
							return 
								switch(i){
									case Input.EOF 		: Iteratee.Done(s, Input.EOF);
									case Input.Empty 	: Iteratee.Cont( function(i:Input<E>) return step(s)(i) );
									case Input.El(e)	: 
										var newS = f(s,e);
										return flatten( newS.map( function(s1) return Iteratee.Cont( step(s1)(i)) ) );
								}
						}
					}
				return Iteratee.Cont( step(state)(i));
			}
	}*/
}
/*class IterVs {
	static public function run<E, A>(iter : IterV<E, A>):A{
		switch iter {
			case Done(a, _): return a;
			case Cont(_) : throw "Computation not finished";
		}
	}
	static public function drop<E,A>(n:Int):IterV<E,A>{
		var step : Input<E> -> IterV<E,A> = null;
		step =
			function(i:Input<E>):IterV<E,A>{
				return 
					switch (i) {
						case El(e)	 	: drop(n-1);
						case Empty 		: Cont(step);
						case EOF	 		: Done(null,EOF);
					}
			}
		return n==0 ? Done(null,Empty) : Cont(step);
	}
	static public function pump<E,A>(s:Stream<Input<E>>,iter:IterV<E,A>):Stream<IterV<E,A>>{
		return 
			s.scanl( iter ,
				function(it,x){
					return 
						switch (it) {
							case Done(a,e) 	: Done(a,e);
							case Cont(k) 		: k(x);
						}
				}
			);
	}
	static public function flatMap<E,A,B>(f1:IterV<E,A>,f2:A->IterV<E,B>){
		return
			switch (f1){
				case Done(x,e) 	:
					switch (f2(x)) {
						case Done(y,_) 	: Done(y,e);
						case Cont(k) 		: k(e);
					}
		 		case Cont(k) 				: Cont( k.andThen( flatMap.p2(f2) ) );
			}
	}
}

class Examples {
public static function enumerate < E, A > () return
	function (arr : LList<E>, it : IterV < E, A > ) : IterV < E, A > {
		switch (arr) {
			case Nil():
				switch it {
					case Done(_, _) : return it;
					case Cont(k) : return k(EOF);
				}
		return it;
			case Cons(e, rest):
				switch it {
					case Done(_, _) : return it;
					case Cont(k) : return enumerate()(rest, k(El(e)));
				};
		}
	}

inline public static function counter<A>(): IterV<A,Int> return {
	function step(n: Int) return
		function (inp : Input<A>) : IterV < A, Int > return
			switch inp {
				case El(x) 	: Cont(step(n + 1));
				case Empty 	: Cont(step(n));
				case EOF 	  : Done(n, EOF);
		}
		Cont(step(0));
	}
}

class Main {

	static function main() {
		var list = Cons(5, Cons(7, Cons(6, Nil)));
		var iter = Examples.enumerate()(list, Examples.counter());

		trace("Result " + IterVs.run(iter));
	}

}*/