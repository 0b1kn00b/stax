package stx.rct;

import stx.Functions;

enum Propagation<T> {
    Negate;
    Propagate(value: Pulse<T>);
}

class Propagations {
  @:noUsing public static function unit<T>() : Pulse<T> -> Propagation<T> {
      return function(pulse : Pulse<T>) : Propagation<T> return Propagate(pulse);
  }
}
