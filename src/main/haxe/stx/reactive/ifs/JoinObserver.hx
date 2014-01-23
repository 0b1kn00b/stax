package stx.async.ifs;

import hx.ifs.Run;

interface JoinObserver extends Dissolvable extends Run{
  public function dequeue():Void;
}