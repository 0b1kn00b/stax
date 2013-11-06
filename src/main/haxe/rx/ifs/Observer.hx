package rx.ifs;

import stx.Fail;
import stx.Chunk;

import hx.ifs.Action;

interface Observer<T> extends Action<Chunk<T>>{
  public function onDone():Void;
  public function onFail(f:Fail):Void;
  public function onData(d:T):Void;
}