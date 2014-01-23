package stx.reactive.ifs;

import stx.async.ifs.Waiting;

import stx.Chunk;

@doc("
  Typically, if you enter a stx.async.ifs.Observer it is transformed automatically to it's abstract counterpart:
  stx.asyncObserver. Likewise stx.async.ifs.Dissolvable.
")
interface Observable<T> extends Waiting<Observer<T>>{

}