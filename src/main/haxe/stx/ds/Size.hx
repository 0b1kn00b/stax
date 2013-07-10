package stx.ds;

typedef SizeType = {
  public var size(get, null)      : Int;
  private function get_size()     : Int;
}
abstract Size(SizeType) from SizeType to SizeType{
  public function new(v){
    this = v;
  }
  public var size(get, never)      : Int;
  private function get_size()      : Int{
    return this.size;
  } 
}