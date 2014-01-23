package hx.reactive.ifs;

interface Dispatcher<T> {
  public function add(h : T -> Void):Void;
  public function rem(h : T -> Void):Void;

  public function clear():Void;
  public function emit(e:T):Bool;

  public function has():Bool;
}