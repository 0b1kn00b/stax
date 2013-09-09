package stx.ifs;

interface MonadOps<T>{
  public function map<U>(fn:T->U):MonadOps<U>;
  public function flatMap<U>(fn:T->MonadOps<U>):MonadOps<U>;
  public function pure<A>(v:A):MonadOps<A>;
  public function typed<C>():C;
}