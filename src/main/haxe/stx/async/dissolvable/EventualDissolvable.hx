package stx.async.dissolvable;

import stx.async.Eventual;

import stx.async.ifs.Dissolvable in IDissolvable;

class EventualDissolvable implements IDissolvable{
  public var dissolved(default,null):Bool;
  private var eventual  : Eventual<Dissolvable>;

  public function new(eventual){
    this.eventual = eventual;
  }
  public function dissolve(){
    if(!dissolved){
      dissolved = true;
      eventual.each(
        function(x){
          x.dissolve();
        }
      );
    }
  }
}