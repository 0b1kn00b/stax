package funk.types;

using Type;
using funk.types.Function4;
using funk.types.Tuple4;
using massive.munit.Assert;

class Function4Test {

    @Test
    public function when_calling__1__should_call_function() : Void {
        var called = false;
        var a = function(value1, value2, value3, value4) {
            called = value1;
        };
        a._1(true)(false, false, false);
        called.isTrue();
    }

    @Test
    public function when_calling__2__should_call_function() : Void {
        var called = false;
        var a = function(value1, value2, value3, value4) {
            called = value2;
        };
        a._2(true)(false, false, false);
        called.isTrue();
    }

    @Test
    public function when_calling__3__should_call_function() : Void {
        var called = false;
        var a = function(value1, value2, value3, value4) {
            called = value3;
        };
        a._3(true)(false, false, false);
        called.isTrue();
    }

    @Test
    public function when_calling__4__should_call_function() : Void {
        var called = false;
        var a = function(value1, value2, value3, value4) {
            called = value4;
        };
        a._4(true)(false, false, false);
        called.isTrue();
    }

    @Test
    public function when_calling_compose__should_call_function_and_return_correct_response() : Void {
        var a = function(value) {
            return value;
        };

        var b = a.compose(function(value1, value2, value3, value4){
            return value1 || value2 || value3 || value4;
        })(false, true, false, false);

        b.isTrue();
    }

    @Test
    public function when_calling_map__should_call_function() : Void {
        var a = function(value1, value2, value3, value4) {
            return value1 || value2 || value3 || value4;
        };

        var b = a.map(function(value){
            return !!value;
        })(false, true, false, false);

        b.isTrue();
    }

    @Test
    public function when_calling_curry__should_call_function() : Void {
        var called = false;
        var a = function(value1, value2, value3, value4) {
            called = true;
            return value1 || value2 || value3 || value4;
        };
        a.curry()(false)(true)(false)(false);
        called.isTrue();
    }

    @xTest
    public function when_calling_uncurry__should_call_function() : Void {
        var called = false;
        var a = function(value1) {
            return function(value2) {
                return function(value3) {
                    return function(value4) {
                        called = true;
                        return value4;    
                    }
                }
            }
        }.uncurry()(1, 2, 3, 4);
        called.isTrue();
    }

    @Test
    public function when_calling_tuple__should_call_function() : Void {
        var a = function(value1, value2, value3, value4) {
            return value1 || value2 || value3 || value4;
        }.untuple()(tuple4(false, true, false, false));
        a.isTrue();
    }

    @Test
    public function when_calling_untuple__should_call_function() : Void {
        var a = function(t : Tuple4<Bool, Bool, Bool, Bool>) {
            return t;
        }.tuple()(false, true, false, false);
        a.areEqual(tuple4(false, true, false, false));
    }

    @Test
    public function when_calling_lazy__should_return_value() : Void {
        var instance = Math.random();
        function(a, b, c, d) {
            return instance + a + b + c + d;
        }.lazy(1, 2, 3, 4)().areEqual(instance + 1 + 2 + 3 + 4);
    }

    @Test
    public function when_calling_lazy_twice__should_return_same_value() : Void {
        var instance = Math.random();
        var lax = function(a, b, c, d) {
            return instance + a + b + c + d;
        };
        lax.lazy(1, 2, 3, 4)();
        lax.lazy(1, 2, 3, 4)().areEqual(instance + 1 + 2 + 3 + 4);
    }

    @Test
    public function when_calling_lazy_twice__should_return_same_instance() : Void {
        var lax = function(a, b, c, d) {
            return Math.random();
        }.lazy(1, 2, 3, 4);
        lax().areEqual(lax());
    }

    @Test
    public function when_calling_lazy_twice__should_be_called_once() : Void {
        var amount = 0;
        var lax = function(a, b, c, d) {
            amount++;
            return {};
        }.lazy(1, 2, 3, 4);
        lax();
        lax();
        amount.areEqual(1);
    }

    @Test
    public function when_enclose_is_called_should_be_called_correctly() : Void {
        var called = false;
        var effect = function(a, b, c, d) {
            called = true;
            return 1;
        }.enclose();
        effect(1, 2, 3, 4);
        called.isTrue();
    }

    @Test
    public function when_swallowWith_is_called_should_return_func_value() : Void {
        var res = function(a, b, c, e) { return 1; }.swallowWith(2)(1, 2, 3, 4);
        res.areEqual(1);
    }

    @Test
    public function when_swallowWith_is_called_should_return_default_value() : Void {
        var res = function(a, b, c, e) { throw "error"; return 1; }.swallowWith(2)(1, 2, 3, 4);
        res.areEqual(2);
    }
}
