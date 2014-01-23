package stx.ds.range;

import stx.ds.ifs.Range in IRange;

class EmptyRange<T> implements IRange<T>{
  public function new(){
  }
  public function done():Bool{
    return true;
  }
  public function peek():T{
    return null;
  }
  public function step():Void{
    
  }
}