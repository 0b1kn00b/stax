package hx.ifs;

interface Command<T>{
  public function invoke(v:T):Void;
}