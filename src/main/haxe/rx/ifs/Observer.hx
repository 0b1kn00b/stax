package rx.ifs;

import stx.Prelude;
import stx.ifs.Command;

interface Observer<T> extends Command<Chunk<T>>{
  public function onDone():Void;
  public function onFail(f:Fail):Void;
  public function onData(d:T):Void;
}