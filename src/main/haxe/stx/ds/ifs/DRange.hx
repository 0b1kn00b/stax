package stx.ds.ifs;

interface DRange<T> extends Range<T>{
  @doc("Increment the Iteration from the back.");
  public function back():Range<T>;
  @doc("What is the next last thing?")
  public function last():T;
}