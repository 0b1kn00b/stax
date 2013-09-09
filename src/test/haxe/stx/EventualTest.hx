package stx;

import stx.Muster;
import stx.Muster.*;
import stx.Log.*;

import traits.ITrait;

import stx.trt.TData;

@:note('Traits not implemented properly, abandoning for now.')
class EventualTest extends TestCase{
  public function testUnit(u:UnitArrow):UnitArrow{    
    return u;
  }
}

interface TEventual<T> extends ITrait extends TData<T>{

}
class _Eventual<T> implements TEventual<T>{
  public function new(){

  }
}