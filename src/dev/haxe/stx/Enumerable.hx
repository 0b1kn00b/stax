package stx;

abstract Enumerable<T>(Iterable<T>) from Iterable<T> to Iterable<T>{
  public function new(v){
    this = v;
  }
  
}