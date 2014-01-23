package stx.reactive.observer;

import Prelude;

import stx.Chunk;


import stx.Fail;

import stx.reactive.ifs.Observer in IObserver;

class DefaultObserver<T> implements IObserver<T>{
  public function new(?_onData:T->Void,?_onFail:Fail->Void,?_onDone:Niladic){
    if(_onData!=null) this._onData = _onData;
    if(_onFail!=null) this._onFail = _onFail;
    if(_onDone!=null) this._onDone = _onDone;
  }
  public function apply(v:Chunk<T>){
    switch (v) {
      case Val(v) : onData(v);
      case End(e) : onFail(e);
      case Nil    : onDone();
    }
  }
  public function onData(v:T){
    this._onData(v);
  }
  public dynamic function _onData(v:T):Void{}

  public function onFail(f:Fail){
    this._onFail(f);
  }
  public dynamic function _onFail(v:Fail):Void{}

  public function onDone(){
    this._onDone();
  }
  public dynamic function _onDone():Void{}
}