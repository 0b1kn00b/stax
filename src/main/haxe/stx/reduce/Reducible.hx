package stx.reduce;

typedef ReducibleType<A> = {
  function reduce<Z>(fn: Reducible<A>, next: Reduce<A,Z>, initial: A) : Z;
}
abstract Reducible<A>(ReducibleType<A>) from ReducibleType<A> to ReducibleType<A>{
  public function new(v){
    this = v;
  }
}