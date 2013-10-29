package stx.time;

abstract Milliseconds(Float) from Float{
  public function new(v){
    this = v;
  }
  @:from static public inline function fromSeconds(s:Seconds):Milliseconds{
    return s * 1000;
  }
  @:to public inline function toSeconds():Seconds{
    return this / 1000;
  }
  public function native(){
    return this;
  }
}