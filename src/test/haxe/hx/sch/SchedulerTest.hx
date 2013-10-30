package hx.sch;

import Type;

import stx.ioc.Inject.*;

import stx.Time;
import stx.Eventual;
import Stax.*;
import stx.Compare.*;
import stx.Log.*;

using stx.Iterables;
using stx.Functions;
using stx.Compose;
using stx.UnitTest;

import hx.sch.ThreadScheduler;
import hx.sch.InlineScheduler;

import stx.Time.*;
import Sys.*;

import neko.vm.Thread;
import neko.vm.Deque;

class SchedulerTest extends TestCase{
  @:note("#0b1kn00b: A `push` for Deque goes on the opposite end from Array.")
  public function devtest_deque(u:UnitArrow):UnitArrow{
    var a = new Deque();
        a.push(1);
        a.push(2);
    var b = a.pop(false);
    return u.add(isEqual(2,b));
  }
  public function test_can_i_crash_the_stack(u:UnitArrow):UnitArrow{
    var evt = Eventual.unit();
    function fn(){
      fn();
    }
    var th  = Thread.create(
      function(){
        try{
          fn();
        }catch(e:Dynamic){
          evt.deliver(isTrue(true));
        }
      }
    );
    sleep(2);
    return u.add(evt.flatten());
  }
  public function testScheduler(u:UnitArrow):UnitArrow{
    trace(info(Date.now()));

    var evt = Eventual.unit();
    var a = new ThreadScheduler();
        a.now(
          function(){
            trace(info(Date.now()));
          }
        );
        a.wait(3,
          function(){
            trace(info(Date.now()));
            evt.deliver(isTrue(true));
          }
        );
        a.wait(2,
          function(){
            trace(info(Date.now()));
          }
        );
        a.latch();
    return u.add(evt.flatten());
  }
  public function testOrder(u:UnitArrow):UnitArrow{
    var evt   = Eventual.unit();
    var stack = [];
    var a = new ThreadScheduler();
        a.now(
          function(){
            stack.push(0);
            trace(info(Date.now()));
          }
        );
        a.now(
          function(){
            stack.push(1);
            trace(info(Date.now()));
          }
        );
        a.now(
          function(){
            stack.push(2);
            evt.deliver(isEqual([0,1,2],stack));
            trace(info(Date.now()));
          }
        );
        a.latch();
    return u.add(evt.flatten());
  }
  public function testInline(u:UnitArrow):UnitArrow{
    var evt = Eventual.unit();
    var a   = new InlineScheduler();
    0.until(3000).foreach(
      function(i){
        a.wait(i/1000,
          function(){
          }
        );
        
      }
    );
    
    a.wait(10,
      function(){
        evt.deliver(isTrue(true));
      }
    );
    a.latch();
    return u.add(evt.flatten());
  }
  public function testInject(u:UnitArrow):UnitArrow{
    var a = inject(hx.ifs.Scheduler);
    return u;
  }
  public function testTimer(u:UnitArrow):UnitArrow{
    var evt   = Eventual.unit();
    var count = 0;
    var a = new hx.sch.Timer(0.01);
        a.run = 
          function(){
            count++;
            if(count == 100){
              //trace('done');
              a.stop();
              evt.deliver(isTrue(true));
            }
          };
        a.start();
    var sch = inject(hx.ifs.Scheduler);
        sch.latch();
    return u.add(evt.flatten());
  }
}

