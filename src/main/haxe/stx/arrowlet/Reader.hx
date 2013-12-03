package stx.arrowlet;

using stx.Arrowlet;

import stx.arrowlet.StateArrowlet;
//Arrowlet<S,Tuple2<A,S>>;

abstract Reader<S,A>(ArrowletState<S,A>) from ArrowletState<S,A> to ArrowletState<S,A>{
  public function new(state){
    this = state;
  }
  public function map<B>(fn:A->B){
    
  }
  /*public function read<B>():Arrowlet<B,S>{
    
  }*/
}