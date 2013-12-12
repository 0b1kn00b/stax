package stx.reduce;

typedef ReduceType<A,Z> = A -> Z -> Z

abstract Reduce<A,Z>(ReduceType<A,Z>) from ReduceType<A,Z> to ReduceType<A,Z>{
  public function new(v){
    this = v;
  }
}