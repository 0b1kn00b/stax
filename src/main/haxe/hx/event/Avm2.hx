package hx.event;

import flash.events.Event;
import flash.events.TextEvent;

@:bug('#0b1kn00b: CHANNEL_MESSAGE, CHANNEL_STATE : 11.4')
class Avm2{
  static public var TABS  : Array<String>  = [Event.TAB_CHILDREN_CHANGE,Event.TAB_ENABLED_CHANGE,Event.TAB_INDEX_CHANGE,];
  static public var LIFE  : Array<String>  = [Event.ADDED,Event.ADDED_TO_STAGE,Event.REMOVED,Event.REMOVED_FROM_STAGE,];
  static public var SOUND : Array<String>  = [Event.ID3,Event.SOUND_COMPLETE,];
  static public var STAGE : Array<String>  = [Event.ACTIVATE,Event.FULLSCREEN,Event.RESIZE,Event.DEACTIVATE,Event.MOUSE_LEAVE,];
  #if flash10
  static public var CLIPBOARD  : Array<String>  = [Event.CLEAR,Event.COPY,Event.CUT,Event.PASTE,Event.SELECT_ALL,
    #if flash11
    Event.TEXT_INTERACTION_MODE_CHANGE,
    #end
  ];
  #end
  //flash 10//Event.EXIT_FRAME,Event.FRAME_CONSTRUCTED,
  //Event.ENTER_FRAME,
  //Event.RENDER,
  static public var GPU   : Array<String>    = [
    #if flash11
      Event.CONTEXT3D_CREATE,
    #end
    #if flash11_4
      Event.TEXTURE_READY,
    #end
  ];
  static public var Base : Array<String> = 
  [
   Event.CANCEL,Event.CHANGE,Event.CLOSE,Event.COMPLETE,Event.CONNECT,
   Event.INIT,Event.OPEN,
   Event.SELECT,
   
   Event.UNLOAD,
   
   #if flash11_3
   /*Event.FRAME_LABEL, belongs elsewhere*/
   /*Event.SUSPEND, null*/
   #end
   #if flash11_4
   Event.CHANNEL_MESSAGE,Event.CHANNEL_STATE,
   Event.VIDEO_FRAME,Event.WORKER_STATE,
   #end
  ];
  static public var TEXT : Array<String> = [TextEvent.TEXT_INPUT,TextEvent.LINK,Event.SCROLL,];
}