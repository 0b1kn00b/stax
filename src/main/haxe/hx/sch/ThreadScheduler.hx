package hx.sch;

import Prelude;


import hx.utl.RetreatTimer;
import hx.utl.Id;

import haxe.Timer;

import stx.Chunk;
import stx.Period;
import Stax.*;

import stx.Fail;
import stx.Log.*;

using stx.Option;
using stx.Iterables;
using stx.Maths;
using stx.Arrays;
using stx.Tuples;

import hx.ifs.Run in IRun;
import hx.ifs.Action in IAction;
import hx.ifs.Scheduler in IScheduler;

#if neko
import Sys.*;
import neko.vm.Deque;
import neko.vm.Thread;
import neko.vm.Lock;
import neko.vm.Mutex;
#end

@doc("Simple thread scheduler. Uses a retreat timer for polling.")
class ThreadScheduler extends BaseScheduler{
  private var started : Bool;
  private var queue   : Deque<Tuple2<Task,Float>>;

  public function new(){
    this.started = false;
    this.queue   = new Deque();
    _run  = function(){
      return Thread.create(
        function(){
          var other = Thread.readMessage(true);
          trace('enter');
          var retreat = new RetreatTimer();
          var count   = 0;
          while(true){
            var itm = queue.pop(false);
            if(itm == null){
              if(count == 0 && started){
                other.sendMessage('exit');
                break;
              }else{
                sleep(retreat.next());
              }
            }else{
              retreat.reset();
              if(itm.snd() < now()){
                trace('run');
                itm.fst().subscribe(
                  function(chk){
                    switch (chk) {
                      case Val(v) : count++;
                      case Nil    : count--;
                      default     :
                    }
                  }
                );
                itm.fst().run();
              }else{
                this.queue.add(itm);
              }
            }
          }
        }
      );
    }
  }
  override public function when(tsk:Task,abs:Float):Void{
    queue.add(tuple2(tsk,abs));
    if(!started){ run(); }
  }
  override public function wait(tsk:Task,rel:Float):Void{
    queue.add(tuple2(tsk,now().add(rel))); 
    if(!started){ run(); }
  }
  override public function immediate(tsk:Task):Void{
    queue.push(tuple2(tsk,now())); 
    if(!started){ run(); }
  }
  private dynamic function _run(){
    return null;
  }
  override public function run(){
    started = true;
    var t   = _run();
    t.sendMessage(Thread.current());
    var out = Thread.readMessage(true);
  }
}