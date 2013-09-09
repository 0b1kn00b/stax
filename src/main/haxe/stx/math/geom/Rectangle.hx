package stx.math.geom;

typedef RectangleType<T:Float> = {
  x : T,
  y : T,
  w : T,
  h : T,
}
abstract Rectangle<T:Float>(RectangleType<T>) from RectangleType<T> to RectangleType<T<{
  public function new(v){
    this = v;
  }
}
class Rectangles{
  
}