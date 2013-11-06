package stx.ifs;

interface Container<T>{
  public var data(get, set):T;
  private function get_data():T;
  private function set_data(value:T):T;
}