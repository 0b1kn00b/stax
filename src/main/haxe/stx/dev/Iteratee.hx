package stx;

import stx.ifs.Apply;
import Prelude;
import stx.Fail;
import stx.Eventual;

using stx.Arrow;
using stx.Iteratee;
using stx.Promise;
using stx.Functions;  

typedef Iterate<E,A> 						= Input<E>    -> Iteratee<E,A>;
private typedef Folder<E,A,B>  	= (Step<E,A>  -> Promise<B>) -> Promise<B>;

enum Step<E,A> {
  Cont(k: Iterate<E, A>);
  Over(a:A, remaining:Input<E>);
  Fail(err:Fail, input:Input<E>);
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
  dynamic public function fold<B>(fn:Step<E,A> -> Promise<B>):Promise<B>{
  	return stx.Fail.create('No `fold` function defined').breach();
  }
  static public function run<E,A,B>(iteratee:Iteratee<E,A>):Promise<A>{
		return iteratee.fold(
			function(step:Step<E,A>){
				return 
					switch (step) {
						case Step.Over(a,_) 		          : Promises.intact(a);
						case Step.Cont(k) 							  :
							k(Input.End).fold(
								function(step1){
									return switch (step1) {
										case Step.Over(a,_) 	    : Promises.intact(a);
										case Step.Cont(_) 				: Promises.breach(stx.Fail.create('Divergent Iteratee after Input.End'));
										case Step.Fail(err,_) 		: Promises.breach(err);
									}
								}
							);
						case Step.Fail(err,_) 		        : Promises.breach(err);
					}
			}
		);
	}
	public function pureFold<B>(folder: Step<E,A> -> B): Promise<B>{
    return this.fold(function(s) return folder(s).intact());
  }
  public function pureFlatFold<B,C>(folder: Step<E,A> -> Iteratee<B,C>): Iteratee<B,C> {
    return Iteratees.flatten(this.pureFold(folder));
  }
  public function fold1<B>(
      done    : A           -> Input<E>         -> Promise<B>
    , cont    : (Input<E>   -> Iteratee<E, A>)  -> Promise<B>
    , error   : Fail       -> Input<E>         -> Promise<B>
    ) : Promise<B>{
      return 
        fold(
          function(step:Step<E,A>):Promise<B>{
            return switch (step) {
              case Step.Over(a,e)       : done(a,e);
              case Step.Cont(k)         : cont(k);
              case Step.Fail(msg,e)    : error(msg,e); 
            }
          }
        );
    }
  public function flatFold<B,C>(
      done  : A -> Input<E>               -> Promise<Iteratee<B,C>>
    , cont  : (Input<E> -> Iteratee<E,A>) -> Promise<Iteratee<B,C>>
    , error : Fail -> Input<E>	          -> Promise<Iteratee<B,C>>
  ):Iteratee<B,C>{
    return Iteratees.flatten(fold1(done,cont,error));
  }
  public function mapOver<B>(f:A->B):Iteratee<E,B>{
    return 
      this.pureFlatFold(
        function(step:Step<E,A>):Iteratee<E,B>{
          return 
            switch (step) {
              case Step.Over(a,e)     : Iteratees.Over(f(a), e);
              case Step.Cont(k)       : Iteratees.Cont(function(i:Input<E>) return k(i).mapOver(f));
              case Step.Fail(err,e)  : Iteratees.Fail(err, e);
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
              case Step.Over(a,e)       :
                if (e == Empty) {
                  f(a);
                }else{
                  f(a).pureFlatFold(
                    function(step1){
                      return 
                        switch (step1) {
                          case Step.Over(a,e)       : Iteratees.Over(a,e);
                          case Step.Cont(k)         : k(e);
                          case Step.Fail(msg,e)  : Iteratees.Fail(msg,e);
                        }
                    }
                  );
                }
              case Step.Cont(k)         : Iteratees.Cont(function(i) return k(i).flatMap(f));
              case Step.Fail(msg,e)    : Iteratees.Fail(msg,e);
            }
        }
    );
  }
  public function map<B>(f:A->B):Iteratee<E,B>{
    return this.flatMap(
      function(a){
        return Iteratees.Over(f(a),Input.Empty);
      }
    );
  }
  public function flatMapInput<B>(f:Step<E,A>->Iteratee<E,B>):Iteratee<E,B>{
    return this.pureFlatFold(f);
  }
}
class Iteratees{
  static public function folds<E,A,B>(it:Iteratee<E,A>,folder:(Step<E,A>->Promise<B>)):Promise<B>{
    return it.fold(folder);
  }
	static public function flatten<E,A>(i: Promise<Iteratee<E, A>>): Iteratee<E, A> {
    return Iteratee.unit(
        function(folder){
          return i.flatMap(folds.p2(folder));
        }
      );
  }
  static public function Over<E,A,B>(a:A,e:Input<E>):Iteratee<E,A>{
    return 
      Iteratee.unit(
        function(folder:Step<E,A>->Promise<B>){
          return folder(Step.Over(a,e));
        }
      );
  }
  static public function Cont<E,A,B>(k:Input<E>->Iteratee<E,A>):Iteratee<E,A>{
    return 
      Iteratee.unit(
        function(folder:Step<E,A>->Promise<B>){
          return folder(Step.Cont(k));
        }
      );
  }
  static public function Fail<E,A,B>(err:Fail,e:Input<E>):Iteratee<E,A>{
    return 
      Iteratee.unit(
        function(folder:Step<E,A>->Promise<B>){
          return folder(Step.Fail(err,e));
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
                      case Input.End    			: Iteratees.Over(s,End);
                      case Input.Empty  			: Iteratees.Cont(function(i) return step(s)(i));
                      case Input.El(e)  			: var s1 = f(s,e); Iteratees.Cont(function(i) return step(s1)(i));
                    }
                  }
              }
        return Iteratees.Cont(function(i) return step(state)(i));
      }
  }
  static public function folderS1<E,A>(state:A):(A->E->Promise<A>)->Iteratee<E,A>{
    return function(f:A->E->Promise<A>){
        var step = null;
            step = 
              function(s:A){
                return function(i:Input<E>){
                  return switch (i) {
                    case Input.End    			: Iteratees.Over(s,End);
                    case Input.Empty  			: Iteratees.Cont(function(i) return step(s)(i));
                    case Input.El(e)  			: var newS = f(s,e); flatten(newS.map(function(s1)return Iteratees.Cont(function(i) return step(s1)(i))));
                  }
                }
            }     
        return Iteratees.Cont(function(i) return step(state)(i));
      }
  }
  static public function folderS2<E,A>(state:A):(A->E->Promise<A>)->Iteratee<E,A>{
    return function(f:A->E->Promise<A>):Iteratee<E,A>{
        var step = null;
            step = 
              function(s:A){
                return 
                  function(i:Input<E>){
                    return switch (i) {
                      case End    		: Iteratees.Over(s, Input.End);
                      case Empty  : Cont(function(i) return step(s)(i));
                      case El(e)  : var newS = f(s, e); flatten(newS.map(function(s1) return Iteratees.Cont(function(i) return step(s1)(i))));
                    }
                  }
              }
        return Iteratees.Cont(function(i) return step(state)(i));
      }
  }
  static public function folderM<E,A>(state:Promise<A>):(A->E->Promise<A>)->Iteratee<E,A>{
    return 
      function(f:A->E->Promise<A>){
        return flatten(state.map(function(s) return folderS2(s)(f)));
      }
  }
}