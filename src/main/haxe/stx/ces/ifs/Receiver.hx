package stx.ces.ifs;

import hx.reactive.ifs.Dispatcher in IDispatcher;

interface Receiver<T:Event> extends IDispatcher<T>{
  public var family(default,null):Int;
}