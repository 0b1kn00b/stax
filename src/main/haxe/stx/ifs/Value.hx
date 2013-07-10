package stx.ifs;
interface Value<T> {
  @:isVar public var value(get, set):T;
  
  private function get_value():T;
  private function set_value(value:T):T;
}