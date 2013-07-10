package stx.math.geom;

typedef TRectangle<T:Float> = {
  x : T,
  y : T,
  w : T,
  h : T,
}
abstract Rectangle<T:Float>(TRectangle<T>) from TRectangle<T> to TRectangle<T<{
  public function new(v){
    this = v;
  }
}
class Rectangles{
  
}