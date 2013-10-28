package stx;

using stx.Iterators;

typedef ManyType<T> = Iterable<T>;

@doc("
  Used for situations where one or many values may equally be used and when it is
  better to avoid the noise of having to wrap single items or remember two function names.
")
abstract Many<T>(ManyType<T>) from ManyType<T> to ManyType<T>{
  public function new(v){
    this = v;
  }
  @:from static public function fromIterator<T>(itr:Iterator<T>):Many<T>{
    return itr.toArray();
  }
  @:from static public function fromT<T>(v:T){
    return [v];
  }
  @:to public function toArray():Array<T>{
    return stx.Iterables.toArray(this);
  }
  public function iterator(){
    return this.iterator();
  }
}