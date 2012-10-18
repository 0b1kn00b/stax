package funk.reactive;

import funk.reactive.Propagation;
import funk.reactive.utils.Timer;

class Stream<T> {

	private var _rank : Int;

	private var _propagator : Pulse<T> -> Propagation<T>;

	private var _listeners : Array<Stream<T>>;

	public function new(	propagator : Pulse<T> -> Propagation<T>,
							sources : Array<Stream<T>> = null
							) {
		_rank = Rank.next();
		_propagator = propagator;
		_listeners = [];

		if(sources != null && sources.length > 0) {
			for(source in sources) {
				source.attachListener(this);
			}
		}
	}

	public function attachListener(listener : Stream<T>) : Void {
		_listeners.push(listener);

		if(_rank > listener._rank) {
			var lowest = Rank.last() + 1;
			var listeners : Array<Stream<T>> = [listener];

            while(listeners.length > 0) {
                var item = listeners.shift();

                item._rank = Rank.next();

                var itemListeners = item._listeners;
                if(itemListeners.length > 0) {
                	listeners = listeners.concat(itemListeners);
            	}
            }
		}
	}

	public function detachListener(listener : Stream<T>): Bool {
        var index = _listeners.length;
        while(--index > -1) {
        	if(_listeners[index] == listener) {
        		_listeners.splice(index, 1);
        		return true;
        	}
        }

        return false;
    }

	public function forEach(func : T -> Void) : Stream<T> {
        Streams.create(function(pulse : Pulse<T>) : Propagation<T> {
            func(pulse.value);

            return Negate;
        }, [this]);

        return this;
    }

    public function constant<E>(value : E) : Stream<E> {
    	return map(function(v) {
    			return value;
    		});
    }

    public function startsWith(value : T) : Signal<T> {
        return new Signal<T>(this, value, function(pulse : Pulse<T>) : Propagation<T> {
            return Propagate(pulse);
        });
    }

    public function map<E>(func : T -> E) : Stream<E> {
    	return Streams.create(function(pulse : Pulse<T>) : Propagation<E> {
    		return Propagate(pulse.map(func));
    	}, [this]);
    }

    public function bind<E>(func : T -> Stream<E>) : Stream<E> {
        var previous: Stream<E> = null;

        var out: Stream<E> = Streams.identity();

        Streams.create(function(pulse : Pulse<T>) : Propagation<E> {
            if (previous != null) {
                previous.detachListener(out);
            }

            previous = func(pulse.value);
            previous.attachListener(out);

            return Negate;
        }, [this]);

        return out;
    }

    public function emit(value : T) : Stream<T> {

    	var pulse = new Pulse<T>(Stamp.next(), value);

    	var queue = new PriorityQueue<{stream: Stream<T>, pulse: Pulse<T>}>();
    	queue.insert(_rank, {stream: this, pulse: pulse});

    	while (queue.length() > 0) {
		    var keyValue = queue.pop();

		    var stream = keyValue.value.stream;
		    var pulse  = keyValue.value.pulse;

		    var propagation: Propagation<T> = stream._propagator(pulse);

		    switch (propagation) {
		        case Propagate(p): {
		            for (listener in stream._listeners) {
		            	var index = listener._rank;
		                queue.insert(index, {stream: listener, pulse: p});
		            }
		        }

		        case Negate:
		    }
		}
		return this;
    }

    public function emitWithDelay(value : T, delay : Int) : Stream<T> {
        Timer.delay(function() {
            emit(value);
        }, delay);

        return this;
    }

    public function delay(signal : Signal<Int>) : Stream<T> {
        var stream : Stream<T> = Streams.identity();

        Streams.create(function(pulse : Pulse<T>) : Propagation<T> {
            stream.emitWithDelay(pulse.value, signal.value);
            return Negate;
        }, [this]);

        return stream;
    }

    public function calm(signal : Signal<Int>) : Stream<T> {
        var stream : Stream<T> = Streams.identity();

        var timer : Timer = null;

        Streams.create(function(pulse : Pulse<T>) : Propagation<T> {
            if(timer != null) {
                timer.stop();
            }

            timer = Timer.delay(function() {
                timer = null;

                stream.emit(pulse.value);
            }, signal.value);

            return Negate;
        }, [this]);

        return stream;
    }

    public function steps() : Stream<T> {
        var time = -1;

        return Streams.create(function(pulse : Pulse<T>) : Propagation<T> {
                return if(pulse.time != time) {
                    time = pulse.time;

                    Propagate(pulse);
                } else {
                    Negate;
                }
            }, [this]);
    }

    public function toArray() : Array<T> {
    	var array : Array<T> = [];
    	forEach(function(value : T) {
    		array.push(value);
    	});
    	return array;
    }

}


private class Rank {

	private static var _value : Int = 0;

    public static function last(): Int {
        return _value;
    }

    public static function next(): Int {
        return _value++;
    }
}

private class Stamp {

    private static var _value : Int = 1;

    public static function last(): Int {
        return _value;
    }

    public static function next(): Int {
        return _value++;
    }
}

private typedef KeyValue<T> = {key: Int, value: T};

private class PriorityQueue<T> {

    var values: Array<KeyValue<T>>;

    public function new() {
        values = [];
    }

    public function length(): Int {
        return values.length;
    }

    public function insert(index : Int, value : T) {
    	var keyValue = {key: index, value: value};

        values.push(keyValue);

        var position = values.length - 1;
        while(position > 0 && index < values[(position - 1) >> 1].key) {
            var previous = position;
            position = (position - 1) >> 1;

            values[previous] = values[position];
            values[position] = keyValue;
        }
    }

    public function isEmpty(): Bool {
        return values.length == 0;
    }

    public function pop(): KeyValue<T> {
        if (values.length == 1) {
            return values.pop();
        }

        var result = values.shift();

        values.unshift(values.pop());

        var position = 0;
		var value = values[0];

		while (true) {
			var len = values.length;
			var valueKey = value.key + 1;

			var leftPosition = position * 2 + 1;
			var rightPosition = position * 2 + 2;

		    var leftChild  = (leftPosition < len ? values[leftPosition].key : valueKey);
		    var rightChild = (rightPosition < len ? values[rightPosition].key : valueKey);

		    if (leftChild > value.key && rightChild > value.key) {
		        break;
		    } else if (leftChild < rightChild) {
		        values[position] = values[leftPosition];
		        values[leftPosition] = value;
		        position = leftPosition;
		    } else {
		        values[position] = values[rightPosition];
		        values[rightPosition] = value;
		        position = rightPosition;
		    }
		}

        return result;
    }
}
