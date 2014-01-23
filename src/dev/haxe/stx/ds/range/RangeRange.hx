package stx.ds.range;

import stx.ds.ifs.Range in IRange;

class RangeRange<T> implements IRange<T>{
  private var ranges  : Range<Range<T>>;
  private var range   : Range<T>;

  public function new(ranges){
    this.ranges = ranges;
    this.range  = ranges.peek();
  }
  public function done():Bool{
    return ranges.done() && range.done();
  }
  public function peek():T{
    return range.peek();
  }
  public function step():Void{
    range.step();
    if(range.done()){
      ranges.step();
      range = ranges.peek();
      if(range == null){
        range = new EmptyRange();
      }
    }
  }
}