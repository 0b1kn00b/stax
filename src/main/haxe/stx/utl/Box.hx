package stx.utl;

import stx.impl.DefaultContainer;

class Box<I,O> extends DefaultContainer<(I,O)>{
  public function new(data){
    super(data);
  }
  public function unbox<A>
}