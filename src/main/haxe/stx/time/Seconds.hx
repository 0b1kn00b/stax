package stx.time;

abstract Seconds(Float) from Float to Float{
  public function new(v){
    this = v;
  }
  @:from static public inline function fromMilliseconds(s:Milliseconds):Seconds{
    return s / 1000;
  }
  @:to public inline function toMilliseconds():Milliseconds{
    return this * 1000;
  }
}