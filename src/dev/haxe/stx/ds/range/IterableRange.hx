package stx.ds.range;

import stx.ds.ifs.Range in IRange;

class IterableRange<T> extends IteratorRange<T>{
  public function new(iterable){
    super(iterable.iterator());
  }
}