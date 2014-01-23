package stx;

typedef StringifyType = { function toString():String; }

abstract Stringify(StringifyType) from StringifyType to StringifyType{
  public function new(v){
    this = v;
  }
  @:from static public function fromString(s:String){
    return {
      toString : function() return s
    }
  }
  public function toString():String{
    return this.toString();
  }
}
class Stringifies{
  static public function toString(s:Stringify):String{
    return s.toString();
  }
}