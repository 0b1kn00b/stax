package stx.ces.ifs;

import Prelude;
import Type;

interface Component{
  public function name():String;
  public function model<T>(unit:Void->T):Option<T>;
}