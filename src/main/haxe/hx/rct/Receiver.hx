package hx.rct;

import stx.utl.Selector;

typedef TReceiver<I> = {
  function selectors():Array<Selector<I>>;
  function on(slct:Selector<I>, handler:I->Void):Void;
  function once(slct:Selector<I>, handler:I->Void):Void;
  function rem(slct : Selector<I>, handler:I->Void):Void;
  function has(slct:Selector<I>):Bool;
}
interface Receiver<I>{
  public function selectors():Array<Selector<I>>;
  public function on(slct:Selector<I>, handler:I->Void):Void;
  public function once(slct:Selector<I>, handler:I->Void):Void;
  public function rem(slct : Selector<I>, handler:I->Void):Void;
  public function has(slct:Selector<I>):Bool;
}
