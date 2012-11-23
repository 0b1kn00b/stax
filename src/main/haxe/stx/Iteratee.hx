package stx;

import stx.macro.F;
import stx.ifs.Apply;
import stx.Prelude;
import stx.Error;
import stx.Future;

using stx.reactive.Arrows;
using stx.Iteratee;
using stx.Promises;
using stx.Functions;

typedef Iterate<E,A> 						= Input<E> -> Iteratee<E,A>;
private typedef Folder<E,A,B>  	= ( Step<E,A> -> Future<Outcome<B>>  ) -> Future<Outcome<B>>;

enum Input<E>{
	El(e:E);
	Empty;
	End;
}
enum Step<E,A> {
  Cont(k: Iterate<E, A>);
  Done(a:A, remaining:Input<E>);
  Error(err:Error, input:Input<E>);
}
class Iteratee<E,A>{
	public function new<B>(opts : { fold : Folder<E,A,B> } ){
    this.fold = opts.fold;
  }
	@:noUsing 
	static public function unit<E,A,B>(fn:Folder<E,A,B>):Iteratee<E,A>{
    return create( { fold : fn } );
  }
  @:noUsing 
  static public function create<E,A,B>(opts:{fold : Folder<E,A,B> }):Iteratee<E,A>{
    return new Iteratee(opts);
  }
  dynamic public function fold<B>(fn:Step<E,A> -> Future<Outcome<B>>):Future<Outcome<B>>{
  	return Promises.failure(stx.Error.create('No `fold` function defined'));
  }
  static public function run<E,A,B>(iteratee:Iteratee<E,A>):Future<Outcome<A>>{
		return 
			iteratee.fold(
				function(step:Step<E,A>){
					return 
						switch (step) {
							case Step.Done(a,remaining) 		: Promises.success(a);
							case Step.Cont(k) 							:
								k(Input.End).fold(
									function(step1){
										return switch (step1) {
											case Step.Done(a,remaining) 	: Promises.success(a);
											case Step.Cont(k) 						: Promises.failure( stx.Error.create('Divergent Iteratee after Input.End') );
											case Step.Error(err,input) 		: Promises.failure(err);
										}
									}
								);
							case Step.Error(err,input) 		: Promises.failure(err);
						}
				}
			);
	}
	public function pureFold<B>(folder: Step<E,A> -> B): Future<Outcome<B>>{
    return this.fold(F.n(s,return Promises.success(folder(s))));
  }
  public function pureFlatFold<B,C>(folder: Step<E,A> -> Iteratee<B,C>): Iteratee<B,C> {
    return Iteratees.flatten(this.pureFold(folder));
  }
  public function fold1<B>(
      done    : A           -> Input<E>         -> Future<Outcome<B>>
    , cont    : (Input<E>   -> Iteratee<E, A>)  -> Future<Outcome<B>>
    , error   : Error       -> Input<E>         -> Future<Outcome<B>>
    ) : Future<Outcome<B>>{
      return 
        fold(
          function(step:Step<E,A>):Future<Outcome<B>>{
            return switch (step) {
              case Step.Done(a,e)       : done(a,e);
              case Step.Cont(k)         : cont(k);
              case Step.Error(msg,e)    : error(msg,e); 
            }
          }
        );
    }
  public function flatFold<B,C>(
      done  : A -> Input<E>               -> Future<Outcome<Iteratee<B,C>>>
    , cont  : (Input<E> -> Iteratee<E,A>) -> Future<Outcome<Iteratee<B,C>>>
    , error : Error -> Input<E>	          -> Future<Outcome<Iteratee<B,C>>>
  ):Iteratee<B,C>{
    return Iteratees.flatten(fold1(done,cont,error));
  }
  public function mapDone<B>(f:A->B):Iteratee<E,B>{
    return 
      this.pureFlatFold(
        function(step:Step<E,A>):Iteratee<E,B>{
          return 
            switch (step) {
              case Step.Done(a,e)     : Iteratees.Done(f(a), e);
              case Step.Cont(k)       : Iteratees.Cont(function(i:Input<E>) return k(i).mapDone(f));
              case Step.Error(err,e)  : Iteratees.Error(err, e);
            }
        }
      );
  }
  public function flatMap<B>(f:A->Iteratee<E,B>):Iteratee<E,B>{
    return
      pureFlatFold(
        function(step:Step<E,A>):Iteratee<E,B>{
          return 
            switch(step){
              case Step.Done(a,e)       :
                if (e == Empty) {
                  f(a);
                }else{
                  f(a).pureFlatFold(
                    function(step1){
                      return 
                        switch (step1) {
                          case Step.Done(a,e)       : Iteratees.Done(a,e);
                          case Step.Cont(k)         : k(e);
                          case Step.Error(msg,e)  : Iteratees.Error(msg,e);
                        }
                    }
                  );
                }
              case Step.Cont(k)         : Iteratees.Cont(F.n(i,return k(i).flatMap(f)));
              case Step.Error(msg,e)    : Iteratees.Error(msg,e);
            }
        }
    );
  }
  public function map<B>(f:A->B):Iteratee<E,B>{
    return 
      this.flatMap(
        function(a){
          return Iteratees.Done(f(a),Input.Empty);
        }
      );
  }
  public function flatMapInput<B>(f:Step<E,A>->Iteratee<E,B>):Iteratee<E,B>{
    return this.pureFlatFold(f);
  }
}
class Iteratees{
  static public function folds<E,A,B>(it:Iteratee<E,A>,folder:(Step<E,A>->Future<Outcome<B>>)):Future<Outcome<B>>{
    return it.fold(folder);
  }
	static public function flatten<E,A>(i: Future<Outcome<Iteratee<E, A>>>): Iteratee<E, A> {
    return 
			Iteratee.unit(
        function(folder){
          return i.flatMapR(folds.p2(folder));
        }
      );
  }
  static public function Done<E,A,B>(a:A,e:Input<E>):Iteratee<E,A>{
    return 
      Iteratee.unit(
        function(folder:Step<E,A>->Future<Outcome<B>>){
          return folder(Step.Done(a,e));
        }
      );
  }
  static public function Cont<E,A,B>(k:Input<E>->Iteratee<E,A>):Iteratee<E,A>{
    return 
      Iteratee.unit(
        function(folder:Step<E,A>->Future<Outcome<B>>){
          return folder(Step.Cont(k));
        }
      );
  }
  static public function Error<E,A,B>(err:Error,e:Input<E>):Iteratee<E,A>{
    return 
      Iteratee.unit(
        function(folder:Step<E,A>->Future<Outcome<B>>){
          return folder(Step.Error(err,e));
        }
      );
  }
  static public function folderS<E,A>(state:A):(A->E->A)->Iteratee<E,A>{
    return 
      function(f:A->E->A){
        var step = null;
            step = 
              function(s:A):Input<E>->Iteratee<E,A>{
                return 
                  function(i:Input<E>){
                    return switch (i) {
                      case Input.End    			: Iteratees.Done(s,End);
                      case Input.Empty  			: Iteratees.Cont(function(i) return step(s)(i));
                      case Input.El(e)  			: var s1 = f(s,e); Iteratees.Cont(function(i) return step(s1)(i));
                    }
                  }
              }
        return Iteratees.Cont(function(i) return step(state)(i));
      }
  }
  static public function folderS1<E,A>(state:A):(A->E->Future<Outcome<A>>)->Iteratee<E,A>{
    return 
      function(f:A->E->Future<Outcome<A>>){
        var step = null;
            step = 
              function(s:A){
                return function(i:Input<E>){
                  return switch (i) {
                    case Input.End    			: Iteratees.Done(s,End);
                    case Input.Empty  			: Iteratees.Cont(function(i) return step(s)(i));
                    case Input.El(e)  			: var newS = f(s,e); flatten(newS.mapR(function(s1)return Iteratees.Cont(function(i) return step(s1)(i))));
                  }
                }
            }     
        return Iteratees.Cont(function(i) return step(state)(i));
      }
  }
  static public function folderS2<E,A>(state:A):(A->E->Future<Outcome<A>>)->Iteratee<E,A>{
    return 
      function(f:A->E->Future<Outcome<A>>):Iteratee<E,A>{
        var step = null;
            step = 
              function(s:A){
                return 
                  function(i:Input<E>){
                    return switch (i) {
                      case End    		: Iteratees.Done(s, Input.End);
                      case Empty  : Cont(function(i) return step(s)(i));
                      case El(e)  : var newS = f(s, e); flatten(newS.mapR(function(s1) return Iteratees.Cont(function(i) return step(s1)(i))));
                    }
                  }
              }
        return Iteratees.Cont(function(i) return step(state)(i));
      }
  }
  static public function folderM<E,A>(state:Future<Outcome<A>>):(A->E->Future<Outcome<A>>)->Iteratee<E,A>{
    return 
      function(f:A->E->Future<Outcome<A>>){
        return flatten(state.mapR(function(s) return folderS2(s)(f)));
      }
  }
}