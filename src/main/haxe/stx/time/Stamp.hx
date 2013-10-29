package stx.time;

abstract Stamp(Float) from Float to Float{
  public function new(v){
    this = v;
  }
}