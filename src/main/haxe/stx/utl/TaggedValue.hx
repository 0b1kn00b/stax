package stx.utl;

import stx.plus.Plus;

class TaggedValue<K,V>{
  public var tag(default,null)    : K;
  public var val(default,null)    : V;

  public function new(tag:K,val:V){
    this.val          = val;
    this.tag          = tag;
  }
}