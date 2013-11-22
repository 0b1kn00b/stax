package stx.time;

import stx.Period in APeriod;
import stx.time.Period in CPeriod;

abstract Second(Float) from Float to Float{
  public function new(v){
    this = v;
  }
  @:to public function toMillisecond():Millisecond{
    return Std.int(this * 1000);
  }
}