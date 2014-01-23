package hx.scheduler;

import Prelude;
using stx.Order;

import stx.Chunk;
import stx.Maths;
import Sys.*;
import stx.Period;
import hx.utl.RetreatTimer;

using stx.Option;
using stx.Arrays;
using stx.Tuples;

import hx.ifs.Scheduler in IScheduler;

#if sys
class InlineScheduler extends BaseScheduler{ 
  private var running : Bool;
  private var retreat : RetreatTimer;
  private var stack   : Array<Tuple2<Float,Task>>;
  private var count   : Int;

  public function new(){
    this.running  = false;
    this.retreat  = new RetreatTimer();
    this.stack    = [];
    this.count    = 0;
  }
  override public function when(tsk:Task,abs:Float):Void{
    stack.push(tuple2(abs,tsk));
  }
  override public function wait(tsk:Task,rel:Float):Void{
    when(tsk,now() + rel);
  }
  override public inline function run(){
    if(!running){
      running = true;
      while( (stack.length > 0 && count > 0) || stack.length > 0){
        var time = now();
        var nstack = [];
        for (val in stack){
          if(val.fst() <= time){
            count++;
            val.snd().subscribe(
              function(chk:Chunk<Unit>){
                switch (chk) {
                  case Nil  : count--;
                  default   :
                }
              }
            );
            val.snd().run();
          }else{
            nstack.push(val);
          }
        }
        if(stack.length == nstack.length){
          var t = retreat.next();
          stack.filter(
            function(x){
              return x.fst() < (time + t);
            }
          ).sortWith(
            function(x,y){
              return Floats.compare(x.fst(),y.fst());
            }
          ).firstOption()
           .each(
            function(x){
              t = x.fst() - time;
            }
          );
          sleep(t);
        }else{
          retreat.reset();
        }
        stack = nstack;
      }   
      running = false;
    }
  }
}
#end