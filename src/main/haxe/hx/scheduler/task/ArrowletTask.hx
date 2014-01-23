package hx.scheduler.task;

import Prelude;

using stx.Arrays;
using stx.async.Arrowlet;

class ArrowletTask extends DefaultTask{
  public function new(arw:Arrowlet<Unit,Unit>){
    super();
    this.arw = arw;
  }
  private var arw : Arrowlet<Unit,Unit>;

  override public function run(){
    running = true;
    state.push(Val(Unit));
    observers.each(function(x) x.apply(Val(Unit)));
    arw.augure(Unit).apply(
      function(u:Unit){
        state.push(Nil);
        observers.each(function(x) x.apply(Nil));
        running = false;
      }
    );
  }
}