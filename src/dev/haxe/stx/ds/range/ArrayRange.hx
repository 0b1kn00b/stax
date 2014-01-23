package stx.ds.range;

import stx.ds.ifs.Range in IRange;

class ArrayRange<T> implements IRange<T>{
  private var array     : Array<T>;
  private var count     : Int;

  public function new(array:Array<T>){
    this.array  = array;
    this.count  = 0;
  }
  public function done():Bool{
    return count >= array.length;
  }
  public function peek():T{
    return array[count];
  }
  public function step():Void{
    count++;
  }
}