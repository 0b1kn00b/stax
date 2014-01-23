package stx.async.arrowlet;

import Prelude;
import stx.async.Arrowlet;

abstract ObserverArrowlet(Arrowlet<Unit,Unit>) from Arrowlet<Unit,Unit> {
  @:from static public function fromFunction0<V>(fn:(Void->Void)->Void):ObserverArrowlet{
    return new Arrowlet(
      function(?i:Unit,cont:Unit->Void){
        var done = false;
        fn(
          function(){
            if(!done){
              cont(i);
              done = true;
            }
          }
        );
      }
    );
  }
  public function new(?v){
    this = v;
  }
}
abstract CallbackArrowlet<V>(Arrowlet<Unit,V>) from Arrowlet<Unit,V> to Arrowlet<Unit,V>{
  @:from static public function fromFunction0<V>(fn:(V->Void)->Void):CallbackArrowlet<V>{
    return new Arrowlet(
      function(?i:Unit,cont:V->Void){
        var done = false;
        fn(
          function(v:V){
            if(!done){
              cont(v);
              done = true;
            }
          }
        );
      }
    );
  }
  public function new(?v){
    this = v;
  }
}