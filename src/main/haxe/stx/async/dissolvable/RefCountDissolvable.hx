package stx.async.dissolvable;

import stx.Compare.*;
import Stax.*;
import Prelude;

import stx.async.ifs.Dissolvable in IDissolvable;

using stx.Iterables;

class RefCountDissolvable implements IDissolvable{

  public var dissolved(default,null) : Bool;
  private var dissolvable : IDissolvable;

  @:allow(stx.async.dissolvable)private var count : Int;
  public function new(dissolvable:IDissolvable){
    assert(dissolvable);
    this.dissolvable = dissolvable;
    count = 0;
  }
  public function dissolve(){
    if(!dissolved && count == 0 && this.dissolvable == null){
      this.dissolvable.dissolve();
      this.dissolvable = null;
    }
  }
  @:allow(stx.async.dissolvable)private function release(){
    this.count--;
  }
  public function lock():Dissolvable{
    return new InnerDissolvable(this);
  }
}
private class InnerDissolvable implements IDissolvable{
  public var dissolved(default,null):Bool;
  private var parent : RefCountDissolvable;
  public function new(parent){
    this.parent = parent;
  }
  public function dissolve(){
    if(!dissolved){
      parent.release();
      this.dissolved = true;
    }
  }
}