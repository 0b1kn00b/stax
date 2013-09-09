package stx.ifs;

typedef ReplyType<T> = {
  function reply() : T;
}
interface Reply<T>{
  public function reply():T;
}