package hx.sch.task;

import stx.Chunk;

using stx.Arrays;

import Stax.*;
import Prelude;

class AnonymousRunTask extends DefaultTask{
  public function new(_run:Niladic){
    super();
    this._run = _run;
  }
  public dynamic function _run(){
    except()(ArgumentError(here().methodName,NullError()));
  }
  override public function run(){
    running = true;
    state.push(Val(Unit));
    observers.each(function(x) x.apply(Val(Unit)));
    _run();
    state.push(Nil);
    observers.each(function(x) x.apply(Nil));
    running = false;
  }
}