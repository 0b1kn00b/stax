package stx.utl;

using stx.Strings;
using stx.Arrays;
      
@doc("Class for diving into Object trees, uses ':' as a delimeter.")
abstract ObjectPath(String) from String to String{
  public function new(v){
    this = v;
  }
  public function parent():ObjectPath{
    return this.split(':').dropRight(1).join(':');
  }
  public function child(str:String):ObjectPath{
    return this.append(':$str');
  }
  public function leaf():ObjectPath{
    return this.split(':').last();
  }
  public function nodes():Array<String>{
    return this.split(':');
  }
  @:static public function fromArray(arr:Array<String>):ObjectPath{
    return arr.join(':');
  }
}