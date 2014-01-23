package stx.async.arrowlet;

import Prelude;
using stx.async.Arrowlet;

typedef ArrowletRightSwitch<A,B,C,D> = Arrowlet<Either<A,B>,Either<A,D>>;

abstract RightSwitch<A,B,C,D>(ArrowletRightSwitch<A,B,C,D>) from ArrowletRightSwitch<A,B,C,D> to ArrowletRightSwitch<A,B,C,D>{
  public function new(v:Arrowlet<B,Either<A,D>>){
    this = new Arrowlet(
      function(?i:Either<A,B>,cont:Either<A,D>->Void){
        switch (i){
          case      Left(l)      : cont(Left(l));
          case      Right(r)     : v.withInput(r,cont);
        }
      }
    );
  }
}