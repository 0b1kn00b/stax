package stx.fnc.ifs;

import stx.fnc.Box in ABox;
interface Boxed{
  public function box<T>():ABox<T>;
}