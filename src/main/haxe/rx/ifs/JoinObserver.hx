package rx.ifs;

import hx.ifs.Run;

interface JoinObserver extends Disposable extends Run{
  public function dequeue():Void;
}