package stx.arw;

import stx.Prelude;
using stx.Eithers;

using stx.arw.Arrows;

abstract ChoiceArrow<B,C>(Arrow<B,C>) from Arrow<B,C> to Arrow<B,C>{
  public function new(v){
    this = v;
  }  
  /*
  public function left<D>():Arrow<Either<B,D>,Either<C,D>>{
    return new LeftChoiceArrow(this);
  }
  public function right<D>():Arrow<Either<D,B>,Either<D,C>>{
    return new RightChoiceArrow(this);
  }
  public function split<D>(with:Arrow<C,D>):Arrow<Either<B,C>,Either<C,D>>{
    return left(this).then( right(with) );    
  }
  public function fanin<D>(with:Arrow<D,C>):Arrow<Either<B,D>,C>{
    return split(this,with).then( Eithers.either.lift() );
  }*/
}