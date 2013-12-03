package hx.rct;

import stx.Log.*;
import Stax.*;

import stx.utl.Selector;
import stx.plus.Equal;

using stx.Functions;
using stx.Bools;
using Prelude;
using stx.Arrays;
using stx.Tuples;
using stx.Option;
using stx.Compose;

typedef Dispatch<I,O>           = Tuple2<Selector<I>,Array<O->Void>>;
typedef DispatchersType<I,O>    = Array<Dispatch<I,O>>;

abstract Dispatchers<I,O>(DispatchersType<I,O>) from DispatchersType<I,O> to DispatchersType<I,O>{
  public function new(){
    this = [];
  }
  public function hasWith(slct:Selector<I>,equal:I->I->Bool):Bool{
    return this.search(
      Tuples2.fst.then(slct.valueEqualsWith.bind(_,equal))
    ).isDefined();
  }
  public function findWith(slct:Selector<I>,handler:O->Void,equal:I->I->Bool):Option<Dispatch<I,O>>{
    return this.search(
      slct.valueEqualsWith.bind(_,equal).pair(Arrays.any.bind(_,handler.equals)).then(Bools.and.tupled())
    );
  }
  public function addWith(slct:Selector<I>,handler:O->Void,equal:I->I->Bool){
    var val = findWith(slct,handler,equal);
    return if(val.isDefined()){
      var arr = val.val().snd();
      if(arr.indexOf(handler) != -1){
        false;
      }else{
        arr.push(handler);
        true;
      }
    }else{
      this.push(tuple2(slct,[handler]));
      true;
    }
  }
  public function remWith(slct:Selector<I>,handler:O->Void,equal:I->I->Bool){
    var val = findWith(slct,handler,equal);
    if(val.isDefined()){
      var arr = val.val().snd();
      for(i in 0...arr.length){
        if(Reflect.compareMethods(arr[i], handler)){
          arr.splice(i, 1)[0];
        }
      }
    }
  }
  public function copy():Dispatchers<I,O>{
    return this.copy();
  }
  public function native(){
    return this;
  }
}