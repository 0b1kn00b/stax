package hx.rct;

import stx.utl.Selector;
import stx.plus.Equal;

using stx.Prelude;
using stx.Arrays;
using stx.Tuples;
using stx.Options;
using stx.Compose;

typedef Dispatch<I,O>           = Tuple2<Selector<I>,Array<O->Void>>;
typedef DispatchersType<I,O>    = Array<Dispatch<I,O>>;

abstract Dispatchers<I,O>(DispatchersType<I,O>) from DispatchersType<I,O> to DispatchersType<I,O>{
  public function new(){
    this = [];
  }
  public function findWith(slct:Selector<I>,equal:I->I->Bool):Option<Dispatch<I,O>>{
    return this.search(Tuples2.fst.then(slct.valueEqualsWith.bind(_,equal)));
  }
  public function addWith(slct:Selector<I>,handler:O->Void,equal:I->I->Bool){
    var val = findWith(slct,equal);
    if(val.isDefined()){
      val.get().snd().push(handler);
    }else{
      this.push(tuple2(slct,[handler]));
    }
  }
  public function remWith(slct:Selector<I>,handler:O->Void,equal:I->I->Bool){
    var val = findWith(slct,equal);
    if(val.isDefined()){
      var arr = val.get().snd();
      for(i in 0...arr.length){
        if(Reflect.compareMethods(arr[i], handler)){
          arr.splice(i, 1)[0];
        }
      }
    }
  }
  public function native(){
    return this;
  }
}