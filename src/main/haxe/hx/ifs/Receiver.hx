package hx.ifs;

import hx.reactive.Selectors;
import stx.utl.Selector;

interface Receiver<I>{
  public var selectors(get, null):Selectors<I,I>;
  private function get_selectors():Selectors<I,I>;
  
  public function on(slct:Selector<I>, handler:I->Void):Void;
  public function once(slct:Selector<I>, handler:I->Void):Void;
  public function rem(slct : Selector<I>, handler:I->Void):Void;
  public function has(slct:Selector<I>):Bool;
}
