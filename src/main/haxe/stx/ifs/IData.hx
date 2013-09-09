package stx.ifs;

interface IData<T>{
  @:isVar public var data(get,set):T;
  private function get_data():T;
  private function set_data(v:T):T;
}