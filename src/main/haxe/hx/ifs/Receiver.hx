package hx.ifs;

import hx.rct.Dispatchers;
import stx.utl.Selector;

interface Receiver<I>{
  public var dispatchers(get, null):Dispatchers<I,I>;
  private function get_dispatchers():Dispatchers<I,I>;
  public function on(slct:Selector<I>, handler:I->Void):Void;
  public function once(slct:Selector<I>, handler:I->Void):Void;
  public function rem(slct : Selector<I>, handler:I->Void):Void;
  public function has(slct:Selector<I>):Bool;
}
