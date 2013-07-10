package stx.ifs;

typedef MonadOps<T> = {
  public function unit():T;
  public function pure<S>(v:S):T;
}