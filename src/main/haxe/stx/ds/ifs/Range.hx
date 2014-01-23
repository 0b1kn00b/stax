package stx.ds.ifs;

interface Range<T>{
  @doc("Are we done yet?")
  public function done():Bool;
  @doc("What is the next thing")
  public function peek():T;
  @doc("give me the next thing.")
  public function step():Void;
}