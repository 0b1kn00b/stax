package stx.rct;

import stx.Functions;

enum Propagation<T> {
    Negate;
    Propagate(value: Pulse<T>);
}

class Propagations {
    public static function identity<T>() : Function1<Pulse<T>, Propagation<T>> {
        return function(pulse : Pulse<T>) : Propagation<T> return Propagate(pulse);
    }
}
