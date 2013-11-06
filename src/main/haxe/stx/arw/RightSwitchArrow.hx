package stx.arw;

import Prelude;
using stx.Arrow;

typedef ArrowRightSwitch<A,B,C,D> = Arrow<Either<A,B>,Either<A,D>>;

abstract RightSwitchArrow<A,B,C,D>(ArrowRightSwitch<A,B,C,D>) from ArrowRightSwitch<A,B,C,D> to ArrowRightSwitch<A,B,C,D>{
  public function new(v:Arrow<B,Either<A,D>>){
    this = new Arrow(
      function(?i:Either<A,B>,cont:Either<A,D>->Void){
        switch (i){
          case      Left(l)      : cont(Left(l));
          case      Right(r)     : v.withInput(r,cont);
        }
      }
    );
  }
}