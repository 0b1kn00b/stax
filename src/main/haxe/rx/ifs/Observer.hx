package rx.ifs;

import stx.Fail;
import stx.Chunk;

import hx.ifs.Action;

interface Observer<T> extends Callback<Chunk<T>>{
  @doc("Notifies the observer of a new element in the sequence.")
  public function onData(d:T):Void;
  @doc("Notifies the observer that an exception has occurred.")
  public function onFail(f:Fail):Void;
  @doc("Notifies the observer of the end of the sequence.")
  public function onDone():Void;
}