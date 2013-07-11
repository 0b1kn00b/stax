package stx.rct;

import haxe.PosInfos;

import stx.Prelude;
import stx.Options;

#if neko
import neko.vm.Thread;
#elseif cpp
import cpp.vm.Thread;
#end

class Process {

    #if nodejs
    #elseif js 
    private static var _performance = untyped __js__('performance || {}; 
            performance.now = (function() {
                return  performance.now || 
                        performance.mozNow ||
                        function() {
                            return new Date().getTime();
                        };
            })();');
    #end

    #if test
    dynamic
    #end
    public static function start(func : CodeBlock, time : Float) : Option<Task> {
        return if(func != null) {
            var task = new Task(func, time);
            task.start();
            Some(task);
        } else None;
    }

    #if test
    dynamic
    #end
    public static function stop(task : Option<Task>) : Option<Task> {
        return switch(task) {
            case Some(value): value.stop(); task;
            case _: None;
        }
    }

    #if test
    dynamic
    #else
    inline
    #end
    public static function stamp() : Float {
        #if nodejs
        return Date.now().getTime();
        #elseif js
        return _performance.now(); 
        #else
        return Date.now().getTime();
        #end
    }
}


