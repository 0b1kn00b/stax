package hx.sch;

using stx.plus.Order;

import stx.Maths;
import Sys.*;
import stx.Time;
import hx.utl.RetreatTimer;

using stx.Option;
using stx.Arrays;
using stx.Tuples;

import hx.ifs.Scheduler in IScheduler;

class InlineScheduler implements IScheduler{ 
  private var retreat : RetreatTimer;
  private var stack   : Array<Tuple2<Float,Run>>;
  public function new(){
    this.retreat  = new RetreatTimer();
    this.stack    = [];
  }
  public inline function when(abs:Float,fn:Run):Void{
    stack.push(tuple2(abs,fn));
  }
  public inline function wait(rel:Float,fn:Run):Void{
    when(Time.now().add(rel),fn);
  }
  public inline function now(fn:Run):Void{
    wait(0,fn);
  }
  public inline function latch(){
    while(stack.length > 0){
      var time = Time.now().toFloat();
      var nstack = [];
      for (val in stack){
        if(val.fst() <= time){
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
         .foreach(
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
  }
}