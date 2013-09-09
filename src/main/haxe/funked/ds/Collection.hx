package funk.ds;

import funk.types.Function1;
import funk.types.Function2;
import funk.types.Function3;
import funk.types.Predicate1;
import funk.types.Predicate2;
import funk.types.Tuple2;

using funk.ds.Collection.CollectionTypes;
using funk.ds.CollectionUtil;
using funk.ds.IteratorUtil;
using funk.ds.extensions.Foldable;
using funk.ds.extensions.Reducible;
using funk.ds.extensions.Dropable;
using funk.types.Any;
using funk.types.Option;

typedef CollectionType<T> = {> Iterable<T>,
    function size() : Int;
};

abstract Collection<T>(CollectionType<T>) from CollectionType<T> to CollectionType<T> {

    inline function new(collection : CollectionType<T>) {
        this = collection;
    }

    inline public function iterator() : Iterator<T> {
        return this.iterator();
    }

    inline public function size() : Int {
        return this.size();
    }

    @:to
    inline public function toFoldable<T>() : Foldable<T> {
        var collection : Collection<T> = this;
        var foldable : Foldable<T> = {
            foldLeft: function(value : T, func : Function2<T, T, T>) {
                return CollectionTypes.foldLeft(collection, value, func);
            },
            foldRight: function(value : T, func : Function2<T, T, T>) {
                return CollectionTypes.foldRight(collection, value, func);
            }
        };
        return foldable;
    }

    @:to
    inline public function toReducible<T>() : Reducible<T> {
        var collection : Collection<T> = this;
        var reducible : Reducible<T> = {
            reduceLeft: function(func : Function2<T, T, T>) return CollectionTypes.reduceLeft(collection, func),
            reduceRight: function(func : Function2<T, T, T>) return CollectionTypes.reduceRight(collection, func)
        };
        return reducible;
    }

    @:to
    inline public function toDropable<T>() : Dropable<T> {
        var collection : Collection<T> = this;
        var dropable : Dropable<T> = {
            dropLeft: function(amount : Int) return CollectionTypes.dropLeft(collection, amount),
            dropRight: function(amount : Int) return CollectionTypes.dropRight(collection, amount),
            dropWhile: function(func : Predicate1<T>) return CollectionTypes.dropWhile(collection, func)
        };
        return dropable;
    }

    @:from
    inline public static function fromArray<T>(array : Array<T>) : Collection<T> {
        return {
            iterator: function() return array.iterator(),
            size: function() return array.length
        };
    }

    @:to
    inline public static function toArray<T>(collection : CollectionType<T>) : Array<T> {
        var array = [];
        var iterator = collection.iterator();
        while(iterator.hasNext()) {
            array.push(iterator.next());
        }
        return array;
    }

    @:to
    inline public static function toString<T>(collection : CollectionType<T>) : String {
        return CollectionTypes.toString(collection);
    }
}

class CollectionTypes {

    inline public static function contains<T>(collection : Collection<T>, value : T, ?func : Predicate2<T, T>) : Bool {
        var result = false;
        var col = collection;
        for(item in col.iterator()) {
            if (AnyTypes.equals(item, value, func)) {
                result = true;
                break;
            }
        }

        return result;
    }

    inline public static function count<T>(collection : Collection<T>, func : Predicate1<T>) : Int {
        var counter = 0;
        var col = collection;
        for(item in col.iterator()) {
            if (func(item)) {
                counter++;
            }
        }
        return counter;
    }

    inline public static function dropLeft<T>(collection : Collection<T>, amount : Int) : Collection<T> {
        if (amount < 0) {
            Funk.error(ArgumentFail('Amount must be positive'));
        }

        var col = collection;
        return if (amount > 0) {
            var exit = false;
            var iterator = col.iterator();

            for (i in 0...amount) {
                if (!iterator.hasNext()) {
                    exit = true;
                    break;
                }
                iterator.next();
            }

            if (exit) {
                CollectionUtil.toCollection([]);
            } else {
                CollectionUtil.toCollection(iterator.toArray());
            }
        } else {
            col;
        }
    }

    inline public static function dropRight<T>(collection : Collection<T>, amount : Int) : Collection<T> {
        var col = collection;

        return if (amount < 0) {
            Funk.error(ArgumentFail('Amount must be positive'));
        } else if (amount == 0) {
            col;
        } else {
            amount = col.size() - amount;

            if (amount <= 0) {
                CollectionUtil.toCollection([]);
            } else {

                var iterator = col.iterator();

                var stack = [];
                for (i in 0...amount) {
                    var h = iterator.next();
                    stack.push(h);
                }

                CollectionUtil.toCollection(stack);
            }
        }
    }

    inline public static function dropWhile<T>(collection : Collection<T>, func : Predicate1<T>) : Collection<T> {
        var exit = false;
        var result = [];

        var col = collection;
        var iterator = col.iterator();
        for (i in iterator) {
            if (!func(i)) {
                result = iterator.toArray();
                result.unshift(i);

                exit = true;
                break;
            }
        }
        return CollectionUtil.toCollection(result);
    }

    inline public static function exists<T>(collection : Collection<T>, func : Predicate1<T>) : Bool {
        var col = collection;
        var result = false;
        for (i in col.iterator()) {
            if (func(i)) {
                result = true;
                break;
            }
        }
        return result;
    }

    inline public static function flatMap<T>(   collection : Collection<T>,
                                                func : Function1<T, Collection<T>>
                                                ) : Collection<T> {
        var col = collection;
        var mapped = [];
        for(item in col.iterator()) {
            var iterator = func(item).iterator();
            mapped = mapped.concat(iterator.toArray());
        }
        return CollectionUtil.toCollection(mapped);
    }

    inline public static function flatten<T>(collection : Collection<T>) : Collection<T> {
        var col = collection;
        return flatMap(col, function(x) {
            return CollectionUtil.toCollection(x);
        });
    }

    inline public static function filter<T>(collection : Collection<T>, func : Predicate1<T>) : Collection<T> {
        var stack = [];
        var clone = [];
        var allFiltered = true;
        var col = collection;

        for (i in col.iterator()) {
            if (func(i)) {
                stack.push(i);
            } else {
                allFiltered = false;
            }
            clone.push(i);
        }

        return if (allFiltered) {
            CollectionUtil.toCollection(clone);
        } else {
            CollectionUtil.toCollection(stack);
        }
    }

    inline public static function filterNot<T>(collection : Collection<T>, func : Predicate1<T>) : Collection<T> {
        var stack = [];
        var clone = [];
        var allFiltered = true;
        var col = collection;

        for (i in col.iterator()) {
            if (!func(i)) {
                stack.push(i);
            } else {
                allFiltered = false;
            }
            clone.push(i);
        }

        return if (allFiltered) {
            CollectionUtil.toCollection(clone);
        } else {
            CollectionUtil.toCollection(stack);
        }
    }

    inline public static function find<T>(collection : Collection<T>, func : Predicate1<T>) : Option<T> {
        var col = collection;
        var result = None;
        for (i in col.iterator()) {
            if (func(i)) {
                result = Some(i);
                break;
            }
        }
        return result;
    }

    inline public static function findIndexOf<T>(collection : Collection<T>, func : Predicate1<T>) : Int {
        var index = 0;
        var col = collection;
        var result = -1;
        for (i in col.iterator()) {
            if (func(i)) {
                result = index;
                break;
            }
            index++;
        }
        return result;
    }

    inline public static function foldLeft<T>(  collection : Collection<T>,
                                                value : T,
                                                func : Function2<T, T, T>
                                                ) : Option<T> {
        var col = collection;
        for(item in col.iterator()) {
            value = func(value, item);
        }
        return Some(value);
    }

    inline public static function foldLeftWithIndex<T>( collection : Collection<T>,
                                                        value : T, func : Function3<T, T, Int, T>
                                                        ) : Option<T> {
        var index = 0;
        var col = collection;
        for(item in col.iterator()) {
            value = func(value, item, index++);
        }
        return Some(value);
    }

    inline public static function foldRight<T>( collection : Collection<T>,
                                                value : T,
                                                func : Function2<T, T, T>
                                                ) : Option<T> {
        var col = reverse(collection);
        for(item in col.iterator()) {
            value = func(value, item);
        }
        return Some(value);
    }

    inline public static function foldRightWithIndex<T>(    collection : Collection<T>,
                                                            value : T,
                                                            func : Function3<T, T, Int, T>
                                                            ) : Option<T> {
        var index = 0;
        var col = reverse(collection);
        for(item in col.iterator()) {
            value = func(value, item, index++);
        }
        return Some(value);
    }

    inline public static function forall<T>(collection : Collection<T>, func : Predicate1<T>) : Bool {
        var col = collection;
        var result = true;
        for (i in col.iterator()) {
            if (!func(i)) {
                result = false;
                break;
            }
        }
        return result;
    }

    inline public static function foreach<T>(collection : Collection<T>, func : Function1<T, Void>) : Void {
        for (i in collection.iterator()) {
            func(i);
        }
    }

    inline public static function get<T>(collection : Collection<T>, index : Int) : Option<T> {
        var col = collection;
        return if (index < 0) {
            None;
        } else {

            var result = None;
            for (i in col.iterator()) {
                if (index == 0) {
                    result = Some(i);
                    break;
                }
                index--;
            }

            result;
        }
    }

    inline public static function indexOf<T>(collection : Collection<T>, value : T) : Int {
        var index = 0;
        var col = collection;
        var result = -1;
        for (i in col.iterator()) {
            if (AnyTypes.equals(i, value)) {
                result = index;
                break;
            }
            index++;
        }
        return result;
    }

    inline public static function map<T, R>(collection : Collection<T>, func : Function1<T, R>) : Collection<R> {
        var mapped = [];
        var col = collection;
        for(item in col.iterator()) {
            mapped.push(func(item));
        }
        return CollectionUtil.toCollection(mapped);
    }

    inline public static function partition<T>( collection : Collection<T>,
                                                func : Predicate1<T>
                                                ) : Tuple2<Collection<T>, Collection<T>> {
        var left = [];
        var right = [];
        var col = collection;
        for (i in col.iterator()) {
            if (func(i)) {
                left.push(i);
            } else {
                right.push(i);
            }
        }

        var leftCol : Collection<T> = CollectionUtil.toCollection(left);
        var rightCol : Collection<T> = CollectionUtil.toCollection(right);

        return tuple2(leftCol, rightCol);
    }

    inline public static function reduceLeft<T>(collection : Collection<T>, func : Function2<T, T, T>) : Option<T> {
        var col = collection;
        return if (size(col) < 1) {
            None;
        } else {

            var iterator = col.iterator();
            var value = iterator.next();
            for (i in iterator) {
                value = func(value, i);
            }

            Some(value);
        }
    }

    inline public static function reduceRight<T>(collection : Collection<T>, func : Function2<T, T, T>) : Option<T> {
        var col = collection;
        return if (size(col) < 1) {
            None;
        } else {

            var iterator = reverse(collection).iterator();
            var value = iterator.next();
            for (i in iterator) {
                value = func(value, i);
            }

            Some(value);
        }
    }

    inline public static function takeLeft<T>(collection : Collection<T>, amount : Int) : Collection<T> {
        var col = collection;
        return if (amount < 0) {
            Funk.error(ArgumentFail('Amount must be positive'));
        } else if (amount == 0) {
            CollectionUtil.zero();
        } else if (amount > size(col)) {
            col;
        } else {

            var iterator = col.iterator();

            var stack = [];
            for (i in 0...amount) {
                stack.push(iterator.next());
            }
            CollectionUtil.toCollection(stack);
        }
    }

    inline public static function takeRight<T>(collection : Collection<T>, amount : Int) : Collection<T> {
        var col = collection;
        return if (amount < 0) {
            Funk.error(ArgumentFail('Amount must be positive'));
        } else if (amount == 0) {
            CollectionUtil.zero();
        } else if (amount > size(col)) {
            col;
        } else {

            var iterator = reverse(collection).iterator();

            var stack = [];
            for (i in 0...amount) {
                stack.push(iterator.next());
            }
            reverse(CollectionUtil.toCollection(stack));
        }
    }

    inline public static function takeWhile<T>(collection : Collection<T>, func : Predicate1<T>) : Collection<T> {
        var stack = [];
        var col = collection;
        for (i in col.iterator()) {
            if (func(i)) {
                stack.push(i);
            }
        }
        return CollectionUtil.toCollection(stack);
    }

    inline public static function zip<T1, T2>(  collection : Collection<T1>,
                                                other : Collection<T2>
                                                ) : Collection<Tuple2<T1, T2>> {
        var col = collection;
        var amount = Std.int(Math.min(size(col), size(other)));

        return if (amount <= 0) {
            CollectionUtil.zero();
        } else {

            var iterator0 = col.iterator();
            var iterator1 = other.iterator();

            var stack = [];
            for (i in 0...amount) {
                stack.push(tuple2(iterator0.next(), iterator1.next()));
            }

            CollectionUtil.toCollection(stack);
        }
    }

    inline public static function append<T>(collection : Collection<T>, item : T) : Collection<T> {
        var col = collection;
        var stack = col.toArray();
        stack.push(item);
        return CollectionUtil.toCollection(stack);
    }

    inline public static function appendAll<T>(collection : Collection<T>, items : Collection<T>) : Collection<T> {
        var col = collection;
        var stack = col.toArray();
        stack = stack.concat(items.toArray());
        return CollectionUtil.toCollection(stack);
    }

    inline public static function appendIterator<T>(    collection : Collection<T>,
                                                        iterator : Iterator<T>
                                                        ) : Collection<T> {
        var col = collection;
        return appendAll(col, iterator.toCollection());
    }

    inline public static function appendIterable<T>(    collection : Collection<T>,
                                                        iterable : Iterable<T>
                                                        ) : Collection<T> {
        var col = collection;
        return appendIterator(col, iterable.iterator());
    }

    inline public static function prepend<T>(collection : Collection<T>, item : T) : Collection<T> {
        var col = collection;
        var stack = col.toArray();
        stack.unshift(item);
        return CollectionUtil.toCollection(stack);
    }

    inline public static function prependAll<T>(collection : Collection<T>, items : Collection<T>) : Collection<T> {
        var col = collection;
        var stack = col.toArray();
        stack = reverse(items).toArray().concat(stack);
        return CollectionUtil.toCollection(stack);
    }

    inline public static function prependIterator<T>(   collection : Collection<T>,
                                                        iterator : Iterator<T>
                                                        ) : Collection<T> {
        var col = collection;
        return prependAll(col, iterator.toCollection());
    }

    inline public static function prependIterable<T>(   collection : Collection<T>,
                                                        iterable : Iterable<T>
                                                        ) : Collection<T> {
        var col = collection;
        return prependIterator(col, iterable.iterator());
    }

    inline public static function head<T>(collection : Collection<T>) : Null<T> {
        var col = collection;
        return if (col.size() < 1) {
            null;
        } else {
            col.iterator().next();
        }
    }

    inline public static function headOption<T>(collection : Collection<T>) : Option<T> {
        var col = collection;
        return if (col.size() < 1) {
            None;
        } else {
            Some(col.iterator().next());
        }
    }

    inline public static function tail<T>(collection : Collection<T>) : Collection<T> {
        var col = collection;
        return if (col.size() < 1) {
            CollectionUtil.zero();
        } else {
            var iterator : Iterator<T> = col.iterator();
            iterator.next();
            var array = iterator.toArray();
            {
                iterator: function() return array.iterator(),
                size: function() return array.length
            }
        }
    }

    inline public static function tailOption<T>(collection : Collection<T>) : Option<Collection<T>> {
        var col = collection;
        var t = tail(col);
        return if (t.size() < 1) {
            None;
        } else {
            Some(t);
        }
    }

    inline public static function reverse<T>(collection : Collection<T>) : Collection<T> {
        var col = collection;

        var result = [];
        var iterator = collection.iterator();
        while(iterator.hasNext()) {
            result.unshift(iterator.next());
        }

        return {
            iterator: function() return result.iterator(),
            size: function() return result.length
        }
    }

    inline public static function size<T>(collection : Collection<T>) : Int {
        var col = collection;
        return col.size();
    }

    inline public static function indices<T>(collection : Collection<T>) : Collection<Int> {
        var stack = [];
        var index = 0;
        var col = collection;
        for (i in col.iterator()) {
            stack.push(index++);
        }
        return CollectionUtil.toCollection(stack);
    }

    inline public static function init<T>(collection : Collection<T>) : Collection<T> {
        var col = collection;
        return dropRight(col, 1);
    }

    inline public static function last<T>(collection : Collection<T>) : Option<T> {
        var value = None;
        var col = collection;
        for (i in col.iterator()) {
            value = Some(i);
        }
        return value;
    }

    inline public static function zipWithIndex<T>(collection : Collection<T>) : Collection<Tuple2<T, Int>> {
        var col = collection;
        var amount = size(col);

        var stack = [];
        var index = 0;
        for (i in col.iterator()) {
            stack.push(tuple2(i, index++));
        }
        return CollectionUtil.toCollection(stack);
    }

    inline public static function isEmpty<T>(collection : Collection<T>) : Bool {
        var col = collection;
        return size(col) < 1;
    }

    inline public static function nonEmpty<T>(collection : Collection<T> ) : Bool {
        var col = collection;
        return !isEmpty(col);
    }

    inline public static function hasDefinedSize<T>(collection : Collection<T>) : Bool {
        var col = collection;
        return nonEmpty(col);
    }

    inline public static function iterable<T>(collection : Collection<T>) : Iterable<T> {
        var col = collection;
        return col;
    }

    inline public static function iterator<T>(collection : Collection<T>) : Iterator<T> {
        var col = collection;
        return col.iterator();
    }

    public static function toString<T>(collection : Collection<T>, ?func : Function1<T, String>) : String {
        var col = collection;
        return if (size(col) < 1) {
            "Collection";
        } else {
            var mapped : Collection<String> = map(col, function(value) return AnyTypes.toString(value, func));
            var folded : Option<String> = foldLeftWithIndex(mapped, '', function(a, b, index) return (index < 1) ? b : '$a, $b');
            'Collection(${folded.get()})';
        }
    }
}
