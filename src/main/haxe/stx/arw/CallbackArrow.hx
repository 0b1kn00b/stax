package stx.arw;

import Prelude;
import stx.Arrow;

abstract ObserverArrow(Arrow<Unit,Unit>) from Arrow<Unit,Unit> {
  @:from static public function fromFunction0<V>(fn:(Void->Void)->Void):ObserverArrow{
    return new Arrow(
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
abstract CallbackArrow<V>(Arrow<Unit,V>) from Arrow<Unit,V> to Arrow<Unit,V>{
  @:from static public function fromFunction0<V>(fn:(V->Void)->Void):CallbackArrow<V>{
    return new Arrow(
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