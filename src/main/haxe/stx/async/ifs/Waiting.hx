package stx.async.ifs;

@doc("Represents a suspended computation that will be completed later.")
interface Waiting<T>{
  public function subscribe(fn:T):stx.async.Dissolvable;
}