package stx.arw;

import js.html.*;

import stx.Prelude;
import stx.arw.Arrows;

abstract EventArrow0(Arrow<EventTarget,Unit>){
  public function new(event:String){
    this = new Arrow(
      function withInput(?i: EventTarget, cont : Dynamic -> Void){
        var cancel    = null;
        var listener  =
          function(x){
            //trace('call: $event');
            cancel();
            cont(Unit);
          }
        cancel =
          function(){
            i.removeEventListener(event,listener);
          };
        i.addEventListener(
          event,
          listener
        );
      }
    );
  }
}
abstract EventArrow1<O>(Arrow<EventTarget,O>){
  public function new(event:String){
    this = new Arrow(
      function withInput(?i: EventTarget, cont : Dynamic -> Void){
        var cancel    = null;
        var listener  =
          function(x:Dynamic){
            //trace('call: $event');
            cancel();
            cont(x);
          }
        cancel =
          function(){
            i.removeEventListener(event,listener);
          };
        i.addEventListener(
          event,
          listener
        );
      }
    );
  }
}