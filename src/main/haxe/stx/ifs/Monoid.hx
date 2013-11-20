package stx.ifs;

interface Monoid<T>{
  public function append(a1:T, a2:T):T;
  public function zero():T;
}