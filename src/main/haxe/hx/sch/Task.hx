package hx.sch;

import stx.Log.*;
import stx.Prelude;

#if neko
  import neko.vm.Thread;
#elseif cpp
  import cpp.vm.Thread;
#elseif java
  import java.vm.Thread;
#elseif cs
  import cs.system.threading.Thread;
#end

class Task{
  @:isVar public var time(default, null)      : Float;
  @:isVar public var func(default, null)      : CodeBlock;
  @:isVar public var cancelled(default,null)  : Bool;

  public function new(func:CodeBlock, time:Float) {
    this.func      = func;
    this.time      = time;
    this.cancelled = false;
  }
  public function start():Void{
    if (time <= 0) {
        stop();
        func();
    }else{
      run = function() {
        stop();
        func();
      };
      var scope = this;
      #if flash9
          id = untyped __global__["flash.utils.setInterval"](function() scope.run(), time);
      #elseif js
          id = untyped __js__("setInterval")(function() scope.run(), time);
      #elseif (neko || cpp || java)
          id = Thread.create(function() scope.loop(Std.int(time)));
      #elseif cs
          //id = 
      #end
    }
  }
  public function stop():Void{
    if (id == null) return;

    cancelled = true;
    
    run = function() {};

    #if flash9
      untyped __global__["flash.utils.clearInterval"](id);
    #elseif js
      untyped __js__("clearInterval")(id);
    #elseif cs
      //id.SetData('stop');
    #elseif (neko || cpp || java)
      id.sendMessage("stop");
    #end

    #if (flash || js)
      id = null;
    #end
  }
  #if (neko || cpp || java)
    private function loop(time_ms:Int):Void{
      var shouldStop = false;
      while (!shouldStop) {
        Sys.sleep(time_ms / 1000);
        // Don't catch any errors here.            
        #if debug(
          try{
            run();
          }catch(e:Dynamic){
            trace(fatal(e));
          }
        );
        #else
          run();
        #end
        var msg = Thread.readMessage(false);
        trace(msg);
        if (msg == "stop") {
            shouldStop  = true;
            id          = null;
        }
      }
    }
  #elseif cs
    #error
  #end

  #if (cs)
    private var slot                          : cs.system.LocalDataStoreSlot;
  #end
  #if (neko||cpp||java||cs)
    private var id                            : Thread;
  #else
    private var id                            : Null<Int>;
  #end

  private var run                             : CodeBlock;
}