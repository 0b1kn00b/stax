package hx.rct;

import flash.events.IEventDispatcher;

import avm2.evt.EventDispatcherOptions;

using stx.Objects;
using stx.Arrays;

class EventDispatcherReactor extends DefaultReactor<Dynamic>{
  private var event_dispatcher : IEventDispatcher;

  public function new(event_dispatcher,listeners:Array<String>,?options:EventDispatcherOptions){
    super();
    options               = EventDispatcherOptionss.defaults().merge(options);
    this.event_dispatcher = event_dispatcher;
    listeners.each(
      function(event){
        this.event_dispatcher.addEventListener(event,this.emit,options.useCapture,options.priority,options.useWeakReference);
      }
    );
  }
}