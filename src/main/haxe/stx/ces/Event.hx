package stx.ces;

import Prelude;

import stx.ces.event.*;

typedef EventType = { type : Thunk<String> }

abstract Event(Event) from Event to Event{
  public function new(v){
    this = v;
  }
  public function fromString(s:String):Event{
    return new DynamicEvent(s);
  }
  public function type(){
    return this.type();
  }
}