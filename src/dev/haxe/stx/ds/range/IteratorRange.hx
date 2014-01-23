package stx.ds.range;

import stx.ds.ifs.Range in IRange;

@:note("This is quite simple minded, it may cause problems depending on whether there are effects in the iterator call bound with other 
  state elsewhere.")
class IteratorRange<T> implements IRange<T>{
  private var _done     : Bool;
  private var iterator  : Iterator<T>;
  private var value     : T;

  public function new(iterator:Iterator<T>){
    this.iterator = iterator;
    this._done    = false;
    step();
  }
  public function done():Bool{
    var o = _done;
    _done = !iterator.hasNext();
    return o;
  }
  public function peek():T{
    return value;
  }
  public function step():Void{
    this.value = if(iterator.hasNext()){
      iterator.next();
    }else{
      null;
    }
  }
}