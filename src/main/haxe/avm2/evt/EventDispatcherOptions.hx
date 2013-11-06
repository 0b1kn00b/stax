package avm2.evt;

typedef EventDispatcherOptions = {
  @:optional var useCapture       : Bool;
  @:optional var priority         : Int;
  @:optional var useWeakReference : Bool;
}
class EventDispatcherOptionss{
  static public function defaults():EventDispatcherOptions{
    return {
      useCapture : false, 
      priority : 0, 
      useWeakReference : false
    };
  }
}