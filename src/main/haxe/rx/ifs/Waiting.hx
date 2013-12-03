package rx.ifs;

@doc("Represents a suspended computation that will be completed later.")
interface Waiting<T>{
  public function subscribe(fn:T):rx.Disposable;
}