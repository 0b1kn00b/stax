package stx.ifs.reactive;

import stx.reactive.Dissolvable;

interface Event<T>{
  public function subscribe(fn:T->Void):Dissolvable;
}