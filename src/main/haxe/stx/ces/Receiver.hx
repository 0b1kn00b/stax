package stx.ces;

import stx.ces.event.DefaultEvent;
import stx.ces.event.DefaultReceiver;

import stx.ces.ifs.Receiver in IReceiver;
import stx.ces.ifs.Event;

abstract Receiver<T:Event>(IReceiver<T>) from IReceiver<T> to IReceiver<T>{
  public function add(h : T -> Void):Void{
    this.add(h);
  }
  public function rem(h : T -> Void):Void{
    this.rem(h);
  }
  public function clear():Void{
    this.clear();
  }
  public function emit(e:T):Bool{
    return this.emit(e);
  }
  public function has():Bool{
    return this.has();
  }
  public var family(get,never):Int;
  private function get_family():Int{
    return this.family;
  }
  @:from static public function fromEventClass<T:Event>(e:Class<T>):Receiver<T>{
    return new DefaultReceiver(e);
  }
}