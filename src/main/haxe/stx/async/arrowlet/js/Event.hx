package stx.async.arrowlet;

import js.html.*;

import Prelude;
import stx.async.Arrowlet;

abstract Event0(Arrowlet<EventTarget,Unit>){
  public function new(event:String){
    this = new Arrowlet(
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
abstract Event1<O>(Arrowlet<EventTarget,O>){
  public function new(event:String){
    this = new Arrowlet(
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