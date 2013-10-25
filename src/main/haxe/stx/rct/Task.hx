package stx.rct;

import stx.Prelude;

#if neko
    import neko.vm.Thread;
#elseif cpp
    import cpp.vm.Thread;
#end
@:note("#Simon: Should use externs for this")
class Task {
    #if (neko||cpp)
        private var id:Thread;
    #else
        private var id:Null<Int>;
    #end

    public var time(get_time, never)  : Float;
    public var func(get_func, never)  : CodeBlock;

    private var _time                 : Float;
    private var _run                  : CodeBlock;
    private var _func                 : CodeBlock;

    private var _isCancelled : Bool;

    public function new(func : CodeBlock, time : Float) {
        _func = func;
        _time = time;

        _isCancelled = false;
    }

    public function start() : Void {
        if (_time <= 0) {
            stop();
            _func();
        } else {
            _run = function() {
                stop();
                _func();
            };
            var scope = this;
            #if flash9
                id = untyped __global__["flash.utils.setInterval"](function() scope._run(), time);
            #elseif js
                id = untyped __js__("setInterval")(function() scope._run(), time);
            #elseif (neko || cpp)
                id = Thread.create(function() scope.runLoop(Std.int(time)));
            #end
        }
    }

    public function stop() : Void {
        if (id == null) return;

        _isCancelled = true;

        _run = function() {};

        #if flash9
            untyped __global__["flash.utils.clearInterval"](id);
        #elseif js
            untyped __js__("clearInterval")(id);
        #elseif (neko || cpp)
            id.sendMessage("stop");
        #end

        #if (flash || js)
        id = null;
        #end
    }

    public function isCancelled() : Bool return _isCancelled;

    #if (neko || cpp)
    private function runLoop(time_ms : Int) : Void {
        var shouldStop = false;
        while (!shouldStop) {
            Sys.sleep(time_ms / 1000);
            // Don't catch any errors here.            
            _run();

            var msg = Thread.readMessage(false);
            if (msg == "stop") {
                shouldStop = true;
                id = null;
            }
        }
    }
    #end

    private function get_time() : Float return _time;
    private function get_func() : CodeBlock return _func;
}