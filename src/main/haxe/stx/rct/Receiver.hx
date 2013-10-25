package stx.rct;

import stx.reactive.Reactive;
import stx.reactive.Streams;

import stx.plus.Equal;

using stx.Eventual;
using stx.Arrow;
using stx.Prelude;
using stx.Arrays;
using stx.Tuples;
using stx.Options;
using stx.Compose;
using stx.Functions;

import stx.rct.*;
import stx.rct.Reactors;
import stx.utl.Selector;

interface Receiver<I>{
  public function selectors():Array<Selector<I>>;
  public function on(slct:Selector<I>, handler:I->Void):I->Void;
  public function once(slct:Selector<I>, handler:I->Void):I->Void;
  public function rem(slct : Selector<I>, handler:I->Void):I-> Void;
  public function has(slct:Selector<I>):Bool;
}
