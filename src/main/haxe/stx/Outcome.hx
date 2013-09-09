package stx;

import stx.Prelude;

import stx.Eithers;
using stx.Options;

/*abstract Outcome<A>(Either<Fail,A>) to Either<Fail,A> from Either<Fail,A>{
  function new(e:Either<Fail,A>) {
    this = e;
  }
  public function map(fn:A->B):Outcome<B>{
    return this.mapR(fn);
  }
  public function flatMap(fn:A->Outcome<B>):Outcome<B>{
    return this.flatMapR(fn);
  }
  /*public function zipWithUsing(o:Outcome<B>,fn:A->B->C,r:Reducer<Fail>){
   this.flatMapR(
    function(x){
      return o.mapR( Tups.t2.bind(x) );
    }
   ).flatMapL(
    function(x){
      return Std.is(FailStack(x)){
        
      }else{
        
      }
    }
   ); 
  }
}*/