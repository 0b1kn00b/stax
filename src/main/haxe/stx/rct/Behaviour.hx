package stx.rct;

import stx.Prelude;
import stx.Functions;

import stx.Options;

import stx.rct.Propagation;
import stx.rct.Pulse;

using stx.rct.Pulse;
using stx.rct.Streams;

using stx.Tuples;

class Behaviour<T> {

    private var _stream : Stream<T>;

    private var _pulse : Function1<Pulse<T>, Propagation<T>>;

    private var _value : T;

    public function new(stream: Stream<T>, value : T, pulse : Function1<Pulse<T>, Propagation<T>>) {
        _value = value;
        _pulse = pulse;

        var collection : Array<Stream<T>> = [stream.steps()];

        _stream = Streams.create(function(pulse : Pulse<T>) : Propagation<T> {
            var prop = _pulse(pulse);
            switch(prop) {
                case Propagate(value): _value = value.value();
                case _:
            }
            return prop;
        }, collection);
    }

    public function stream() : Stream<T> return _stream;
    
    public function value() : T return _value;
}

class BehaviourTypes {

    public static function constant<T>(value: T): Behaviour<T> return Streams.identity(None).startsWith(value);

    public static function dispatch<T>(behaviour : Behaviour<T>, value : T) : Void behaviour.stream().dispatch(value);

    public static function lift<T, R>(behaviour : Behaviour<T>, func : Function1<T, R>) : Behaviour<R> {
        return behaviour.stream().map(func).startsWith(func(behaviour.value()));
    }

    public static function map<T, R>(    behaviour : Behaviour<T>,
                                        stream : Stream<T>,
                                        mapper : Behaviour<Function1<T, R>>
                                        ) : Behaviour<R> {
        return stream.map(function(x) return mapper.value()(x)).startsWith(mapper.value()(behaviour.value()));
    }

    public static function sample(behaviour : Behaviour<Float>) : Behaviour<Float> {
        return Streams.timer(behaviour).startsWith(Process.stamp());
    }

    public static function values<T>(behaviour : Behaviour<T>) : Array<T> return behaviour.stream().values();

    public static function zip<T1, T2>(behaviour : Behaviour<T1>, that : Behaviour<T2>) : Behaviour<Tuple2<T1, T2>> {
        return zipWith(behaviour, that, function(a, b) return tuple2(a, b));
    }

    public static function zipIterable<T>(    behaviours: Array<Behaviour<T>>
                                            ) : Behaviour<Array<T>>  {
        function mapToValue(): Array<T> {
            return behaviours.map(function(behaviour) return behaviour.value());
        }

        var sources : Array<Stream<T>> = behaviours.map(function(behaviour) return behaviour.stream());
        var stream = Streams.create(function(pulse) return Propagate(pulse.withValue(mapToValue())), sources);

        return stream.startsWith(mapToValue());
    }

    public static function zipWith<T, E1, E2>(    behaviour : Behaviour<T>,
                                                that : Behaviour<E1>,
                                                func : Function2<T, E1, E2>
                                                ) : Behaviour<E2> {

        var array : Array<Behaviour<Dynamic>> = [behaviour, that];
        var behaviours : Array<Behaviour<Dynamic>> = array;

        var sources : Array<Stream<Dynamic>> = behaviours.map(function(behaviour) return behaviour.stream());

        var stream = Streams.create(function(pulse : Pulse<E1>) : Propagation<E2> {
            var result = func(behaviour.value(), that.value());
            return Propagate(pulse.withValue(result));
        }, cast sources);

        return stream.startsWith(func(behaviour.value(), that.value()));
    }
}
