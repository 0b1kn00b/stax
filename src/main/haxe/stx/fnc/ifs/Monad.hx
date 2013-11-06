package stx.fnc.ifs;

import stx.fnc.ifs.Pure in IPure;
import stx.fnc.ifs.Copure in ICopure;

import stx.ifs.Container;

import stx.fnc.Pure;
import stx.fnc.Copure;
import stx.fnc.Box in ABox;
import stx.fnc.Monad in AMonad;

interface Monad<S,T> extends Boxed extends Container<S> extends IPure<AMonad<Dynamic>>{
  public function box<V>():ABox<V>;
  public function pure<U>(v:U):AMonad<U>;
  public function flatMap<U>(fn:T->AMonad<U>,?self:Dynamic):AMonad<U>;
  public function flatten<T>(?self:Dynamic):AMonad<T>;
  public function map<U>(fn:T->U,?self:Dynamic):AMonad<U>;
  public function iterator():Iterator<T>;
}