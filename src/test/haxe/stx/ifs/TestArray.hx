package stx.ifs;

import stx.ifs.SemiGroup;

class TestArray<T> implements tink.lang.Cls implements SemiGroupOps<T>{
  @:forward         var impl  : Array<T>;
            public  var ops   : SemiGroupType<SemiGroupOps<T>>;

  public function new(){
    this.impl = [];
    this.ops  = {
      append : cast stx.Arrays.append
    }
  }
}