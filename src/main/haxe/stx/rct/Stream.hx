package stx.rct;
 
import stx.Fail.*;
import Prelude;

import stx.rct.Propagation;
import stx.rct.Stream;
import hx.sch.Process;

import stx.Anys;
import stx.Functions;
import stx.Compare;

using stx.Arrays;
using stx.Iterables;
using stx.Option;
using stx.ds.List;
using stx.Tuples;
using stx.rct.Pulse;

class Stream<T> {

    private var _rank               : Int;
    private var _weakRef            : Bool;
    private var _propagator         : Pulse<T> -> Propagation<T>;
    private var _listeners          : Array<Stream<T>>;
    private var _finishedListeners  : List<Niladic>;

    public function new(propagator : Pulse<T> -> Propagation<T>) {
        _rank = Rank.next();
        _propagator = propagator;
        _listeners = [];

        _weakRef = false;

        _finishedListeners = List.create();
    }

    public function attach(listener : Stream<T>) : Void {
        _listeners.push(listener);

        if(_rank > listener._rank) {
            var listeners : Array<Stream<T>> = [listener];

            while(listeners.length > 0) {
                var item = listeners.shift();

                item._rank = Rank.next();

                var itemListeners = item._listeners;
                if(itemListeners.length > 0) listeners = listeners.concat(itemListeners);
            }
        }
    }

    public function detach(listener : Stream<T>, ?weakReference : Bool = false): Bool {
        var removed = false;

        var index = _listeners.length;
        while(--index > -1) {
            if(_listeners[index] == listener) {
                _listeners.splice(index, 1);
                removed = true;
                break;
            }
        }

        if(weakReference && _listeners.length == 0) finish();

        return removed;
    }

    public function dispatch(value : T) : Stream<T> {
        var time = Process.stamp();
        var pulse = Pulse(time, value);

        // This will propagate through all listeners
        var queue = new PriorityQueue<{stream: Stream<T>, pulse: Pulse<T>}>();
        queue.insert(_rank, {
            stream: this,
            pulse: pulse
        });

        while (queue.size() > 0) {
            var keyValue = queue.pop().value;

            var stream = keyValue.stream;
            var pulse  = keyValue.pulse;

            switch (stream._propagator(pulse)) {
                case Propagate(p): {
                    var weak = true;

                    for (listener in stream._listeners) {
                        weak = weak && listener.weakRef();

                        queue.insert(listener._rank, {stream: listener, pulse: p});
                    }

                    if(stream._listeners.length > 0 && weak) stream.finish();
                }

                case _:
            }
        }

        return this;
    }

    public function finish() : Void {
        // TODO : We should prevent it from coming back.
        var value = true;

        if(_weakRef != value) {
            _weakRef = value;

            if(_weakRef) {
                _finishedListeners.each(function(func) func());
                _finishedListeners = List.create();
            }
        }
    }

    public function whenFinishedDo(func : Niladic) : Void {
        if(_weakRef) {
            func();
        } else {
            if (!_finishedListeners.has(func,Reflect.compareMethods)) {
                _finishedListeners = _finishedListeners.cons(func);
            }
        }
    }

    public function weakRef() : Bool return _weakRef;
}
private class Rank {

    private static var _value : Int = 0;

    static public function last(): Int return _value;

    static public function next(): Int return _value++;
}

private typedef KeyValue<T> = {
    key: Int,
    value: T
};

private class PriorityQueue<T> {

    private var _values : Array<KeyValue<T>>;

    public function new() {
        _values = [];
    }

    public function insert(index : Int, value : T) : Void {
        var keyValue = {
            key: index,
            value: value
        };

        var added = false;

        for (i in 0..._values.length) {
            var val = _values[i];

            if (index > val.key) {
                added = true;

                _values.insert(i, keyValue);

                break;
            }
        }

        if (!added) _values.push(keyValue);
    }

    public function pop() : KeyValue<T> return _values.pop();

    public function size(): Int return _values.length;
}