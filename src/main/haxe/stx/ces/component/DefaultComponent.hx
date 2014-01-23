package stx.ces.component;

import Type;
import Prelude;
import stx.ces.ifs.Component in IComponent;

class DefaultComponent implements IComponent{
  private var __name__ : String;
  public function name(){
    return __name__;
  }
  public function model<T>(unit:Void->T):Option<T>{
    return Some(cast this);
  }
  public function new(__name__){
    this.__name__ = __name__;
  }
}