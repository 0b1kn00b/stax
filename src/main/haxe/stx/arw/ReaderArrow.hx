package vnl.arw;

//Arrow<S,Tuple2<A,S>>;

abstract ReaderArrow(ArrowState<S,A>)<S,A> from ArrowState<S,A> to ArrowState<S,A>{
  public function new(state){
    this = v;
  }
  public function map<B>(fn:A->B){
    return this.map(fn);
  }
  public function read<B>():Arrow<B,S>{
    
  }
}