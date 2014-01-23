package stx.ces.component;

import Prelude;
import Stax.*;

class DelegateComponent<T> extends DefaultComponent{
  private var __component__ : T;
  public function new(__component__){
    this.__component__ = __component__;
    super(Right(vtype(__component__)));
  }
}
