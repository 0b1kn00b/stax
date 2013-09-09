package stx.arw;

using stx.Arrows;

import stx.arw.StateArrow;
//Arrow<S,Tuple2<A,S>>;

abstract ReaderArrow<S,A>(ArrowState<S,A>) from ArrowState<S,A> to ArrowState<S,A>{
  public function new(state){
    this = state;
  }
  public function map<B>(fn:A->B){
    
  }
  /*public function read<B>():Arrow<B,S>{
    
  }*/
}