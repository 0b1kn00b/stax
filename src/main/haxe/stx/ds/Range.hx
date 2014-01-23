package stx.ds;

import Prelude;
import Stax.*;

import stx.ds.range.RangeRange;
import stx.ds.range.IterableRange;
import stx.ds.range.IteratorRange;
import stx.ds.range.EmptyRange;
import stx.ds.range.ArrayRange;

import stx.ds.ifs.Range in IRange;

abstract Range<T>(IRange<T>) from IRange<T> to IRange<T>{
  static public function unit<T>():Range<T>{
    return new EmptyRange();
  }
  public function new(v){
    this = v;
  }
  @:from static public function fromArray<T>(array:Array<T>):Range<T>{
    return new ArrayRange(array);
  }
  @:from static public function fromIterable<T>(iterable:Iterable<T>):Range<T>{
    return new IterableRange(iterable);
  }
  @:from static public function fromIterator<T>(iterable:Iterator<T>):Range<T>{
    return new IteratorRange(iterable);
  }
  public function done():Bool{
    return this.done();
  }
  public function peek():T{
    return this.peek();
  }
  public function step():Void{
    this.step();
  }
}
class Ranges{
  static public function each<A>(range:Range<A>,fn:A->Void){
    while(!range.done()){
      fn(range.peek());
      range.step();
    }
  }
  static public function fold<A,Z>(range:Range<A>,zero:Thunk<Z>,unit:A->Z,plus:Z->Z->Z):Z{
    var out = zero();
    while(!range.done()){
      out = plus(out,unit(next(range)));
    }
    return out;
  }
  static public function next<A>(range:Range<A>):A{
    var val = range.peek();
    range.step();
    return val;
  }
  static public function append<A>(range0:Range<A>,range1:Range<A>):Range<A>{
    return new RangeRange([range0,range1]);
  }
}