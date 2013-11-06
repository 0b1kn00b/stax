package stx.fnc.mnd;

import Stax.*;
import Prelude;

using stx.Tuples;
using stx.Compose;

class State<S,R> extends Base<S->Tuple2<R,S>,R>{
  public function new(apply){
    super(apply);
  }
  dynamic public function apply<S>(s:S):Tuple2<R,S>{
    return except()(AbstractMethodError());
  }
  inline override public function flatMap<R1>(fn:R->Monad<R1>,?self:State<S,R>):Monad<R1>{
    self = self == null ? this : self;
    return box().box(function(s:S){
      var oc = self.box().unbox()(s);
      return switch(oc){
        case tuple2(r,s)     : box().box(fn(r)).box().unbox();
      }
    });
  }
  inline override public function map<R1>(fn:R->R1,?self:State<S,R>):Monad<R1>{
    self = self == null ? this : self;
    return self.box().box(function(s:S){
      var oc = self.box().unbox()(s);
      return switch(oc) {
        case tuple2(r,s): tuple2(fn(r),s);
      }
    });
  }
}