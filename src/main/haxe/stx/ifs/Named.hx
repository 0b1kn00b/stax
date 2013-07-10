package stx.ifs;

interface Named{
  public var name(get,set):String;
  private function get_name():String;
  private function set_name(s:String):String;
}