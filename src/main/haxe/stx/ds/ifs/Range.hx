package stx.ds.ifs;

interface Range<T>{
  @doc("Are we done yet?")
  public function done():Bool;
  @doc("What is the next thing")
  public function peek():T;
  @doc("Increment the iteration")
  public function next():Range<T>;
}