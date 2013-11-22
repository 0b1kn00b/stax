package stx.time;

abstract Millisecond(Int) from Int{
  public function new(?v){
    this = v == null ? 1. : v;
  }
  @:to public inline function toSecond():Second{
    return this / 1000;
  }
}