package rx.ifs;

import stx.Prelude;
import stx.ifs.Apply;

interface Observer<T> extends Apply<Chunk<T>,Void>{
  public function onDone():Void;
  public function onFail(f:Fail):Void;
  public function onData(d:T):Void;
}