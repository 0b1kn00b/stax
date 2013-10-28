package stx.time;

enum MarkType{
  Absolute(d:Date);
  Relative(t:Time);
}

abstract Mark(MarkType) from MarkType to MarkType{
  public function new(v){
    this = v;
  }
  @:from static public inline function fromDate(d:Date):Mark{
    return Absolute(d);
  }
  @:from static public inline function fromTime(t:Time):Mark{
    return Relative(d);
  }
}