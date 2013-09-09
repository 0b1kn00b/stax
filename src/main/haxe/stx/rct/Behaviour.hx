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

    private var pulse                         : Function1<Pulse<T>, Propagation<T>>;
    @:isVar public var value(default,null)    : T;
    @:isVar public var stream(default,null)   : Stream<T>;

    public function new(stream: Stream<T>, value : T, pulse : Function1<Pulse<T>, Propagation<T>>) {
      this.value = value;
      this.pulse = pulse;

      var collection : Array<Stream<T>> = [stream.steps()];

      this.stream = Streams.create(function(pulse : Pulse<T>) : Propagation<T> {
        var prop = this.pulse(pulse);
          switch(prop) {
            case Propagate(bhv): this.value = bhv.value;
            case _:
          }
          return prop;
      }, collection);
    }

}

class BehaviourTypes {

    static public function constant<T>(value: T): Behaviour<T> return Streams.pure(None).startsWith(value);

    static public function dispatch<T>(behaviour : Behaviour<T>, value : T) : Void behaviour.stream().dispatch(value);

    static public function lift<T, R>(behaviour : Behaviour<T>, func : Function1<T, R>) : Behaviour<R> {
        return behaviour.stream.map(func).startsWith(func(behaviour.value));
    }

    static public function map<T,R>(behaviour:Behaviour<T>, stream:Stream<T>, mapper:Behaviour<Function1<T, R>>):Behaviour<R>{
        return stream.map(function(x) return mapper.value(x)).startsWith(mapper.value(behaviour.value));
    }

    static public function sample(behaviour : Behaviour<Float>) : Behaviour<Float> {
        return Streams.timer(behaviour).startsWith(Process.stamp());
    }

    static public function values<T>(behaviour : Behaviour<T>) : Array<T> return behaviour.stream.values();

    static public function zip<T1, T2>(behaviour : Behaviour<T1>, that : Behaviour<T2>) : Behaviour<Tuple2<T1, T2>> {
        return zipWith(behaviour, that, function(a, b) return tuple2(a, b));
    }

    static public function zipIterable<T>(behaviours: Array<Behaviour<T>>):Behaviour<Array<T>>{
        function mapToValue(): Array<T> {
            return behaviours.map(function(behaviour) return behaviour.value);
        }

        var sources : Array<Stream<T>> = behaviours.map(function(behaviour) return behaviour.stream);
        var stream = Streams.create(function(pulse) return Propagate(pulse.withValue(mapToValue())), sources);

        return stream.startsWith(mapToValue());
    }

    static public function zipWith<T,E1,E2>(behaviour:Behaviour<T>, that:Behaviour<E1>, func:Function2<T,E1,E2>):Behaviour<E2> {
        var array       : Array<Behaviour<Dynamic>>   = [behaviour, that];
        var behaviours  : Array<Behaviour<Dynamic>>   = array;
        var sources     : Array<Stream<Dynamic>>      = behaviours.map(function(behaviour) return behaviour.stream);

        var stream = Streams.create(function(pulse : Pulse<E1>) : Propagation<E2> {
            var result = func(behaviour.value, that.value);
            return Propagate(pulse.withValue(result));
        }, cast sources);

        return stream.startsWith(func(behaviour.value, that.value));
    }
}
