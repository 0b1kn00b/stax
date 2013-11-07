package stx.fnc.mnd;

import Prelude;
import Stax.*;

import stx.Fail;

import stx.impl.DefaultContainer;

import stx.fnc.ifs.Monad in IMonad;
import stx.fnc.Box;
import stx.fnc.Box in ABox;

using stx.Compose;

class Base<S,T> implements IMonad<S,T> extends DefaultContainer<S>{
  public function new(data:S){
    super(data);
  }
  public function box<V>():ABox<V>{
    return cast new Box(this);
  }
  public function iterator():Iterator<T>{
    return except()(AbstractMethodError());
  }
  public function pure<U>(v:U):Monad<U>{
    return except()(AbstractMethodError());
  }
  public function flatMap<U>(fn:T->Monad<U>,?self:Dynamic):Monad<U>{
    return except()(AbstractMethodError());
  }
  public function map<U>(fn:T->U,?self:Dynamic):Monad<U>{
    return this.flatMap(self,fn.then(pure));
  }
  public function flatten(?self:Dynamic){
    self = self == null ? this : self;
    return flatMap(self,pure);
  }
}