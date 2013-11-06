package stx.arw.avm2;

import flash.events.Event;
import flash.events.IEventDispatcher;

abstract EventArrow(Arrow<IEventDispatcher,Event>) from Arrow<IEventDispatcher,Event> to Arrow<IEventDispatcher,Event>{
  public function new(v){
    this = v;
  }
  static public function pure(str:String):EventArrow{
    return fromString(str);
  }
  @:from static public function fromString(str:String):EventArrow{
    return function(dispatcher:IEventDispatcher,cont:Event->Void):Void{
      EventArrows.once(dispatcher,str,cont);
    }
  }
}
class EventArrows{
  static public function once(dispatcher:IEventDispatcher,key:String,fn:Event->Void):Void{
    function handler(e:Event){
      fn(e);
      dispatcher.removeEventListener(key,handler);
    }
    dispatcher.addEventListener(key,fn);
  }
}