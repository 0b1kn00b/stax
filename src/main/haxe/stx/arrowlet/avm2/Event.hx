package stx.arrowlet.avm2;

import flash.events.Event;
import flash.events.IEventDispatcher;

abstract EventArrowlet(Arrowlet<IEventDispatcher,Event>) from Arrowlet<IEventDispatcher,Event> to Arrowlet<IEventDispatcher,Event>{
  public function new(v){
    this = v;
  }
  static public function pure(str:String):EventArrowlet{
    return fromString(str);
  }
  @:from static public function fromString(str:String):EventArrowlet{
    return function(dispatcher:IEventDispatcher,cont:Event->Void):Void{
      EventArrowlets.once(dispatcher,str,cont);
    }
  }
}
class EventArrowlets{
  static public function once(dispatcher:IEventDispatcher,key:String,fn:Event->Void):Void{
    function handler(e:Event){
      fn(e);
      dispatcher.removeEventListener(key,handler);
    }
    dispatcher.addEventListener(key,fn);
  }
}