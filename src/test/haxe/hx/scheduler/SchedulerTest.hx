package hx.scheduler;

import Prelude;
import Type;

import stx.ioc.Inject.*;

import stx.Period;
import stx.async.Eventual;
import Stax.*;
import stx.Compare.*;
import stx.io.Log.*;

using stx.Iterables;
using stx.Functions;
using stx.Compose;
using stx.UnitTest;

import hx.scheduler.ThreadScheduler;
import hx.scheduler.InlineScheduler;

import stx.Period.*;
import Sys.*;

#if neko
import neko.vm.Thread;
import neko.vm.Deque;
#end

class SchedulerTest extends Suite{
  @:note("#0b1kn00b: A `push` for Deque goes on the opposite end from Array.")
  #if neko
  public function devtest_deque(u:TestCase):TestCase{
    var a = new Deque();
        a.push(1);
        a.push(2);
    var b = a.pop(false);
    return u.add(isEqual(2,b));
  }

  public function _test_can_i_crash_the_stack(u:TestCase):TestCase{
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
    return u.add(evt);
  }

  public function testThreadScheduler(u:TestCase):TestCase{
    trace(info(Date.now()));

    var evt = Eventual.unit();
    var a = new ThreadScheduler();
        a.immediate(
          function(){
            trace(info(Date.now()));
          }
        );
        a.wait(
          function(){
            trace(info(Date.now()));
            evt.deliver(isTrue(true));
          }
        ,3);
        a.wait(
          function(){
            trace(info(Date.now()));
          }
        ,2);
        a.run();
    return u.add(evt);
  }
  
  @:note('undefined order not ideal')
  public function testOrder(u:TestCase):TestCase{
    var evt   = Eventual.unit();
    var stack = [];
    var a = new ThreadScheduler();
        a.immediate(
          function(){
            stack.push(0);
            trace(info(Date.now()));
          }
        );
        a.immediate(
          function(){
            stack.push(1);
            trace(info(Date.now()));
          }
        );
        a.immediate(
          function(){
            stack.push(2);
            evt.deliver(isEqual([0,2,1],stack));
            trace(info(Date.now()));
          }
        );
        a.run();
    return u.add(evt);
  }
  #end
  #if sys
  public function testInline(u:TestCase):TestCase{
    var evt = Eventual.unit();
    var a   = new InlineScheduler();
    0.until(3000).each(
      function(i){
        a.wait(
          function(){
          }
        ,i/1000);
        
      }
    );
    
    a.wait(
      function(){
        evt.deliver(isTrue(true));
      }
    ,10);
    a.run();
    return u.add(evt);
  }
  #end
  public function testInject(u:TestCase):TestCase{
    var a = inject(hx.ifs.Scheduler);
    return u;
  }
 public function testTimer(u:TestCase):TestCase{
    var evt   = Eventual.unit();
    var count = 0;
    var a = new hx.Timer(0.01);
        a.run = 
          function(){
            count++;
            if(count == 3){
              //trace('done');
              a.stop();
              evt.deliver(isTrue(true));
            }
          };
        a.start();
    var sch = inject(hx.ifs.Scheduler);
        sch.run();
    return u.add(evt);
  }
  /*public function test_stop_start(u:TestCase):TestCase{
    var count = 0;
    var a = inject(hx.ifs.Scheduler);
    a.wait(function(){count++;},0.3);
    a.run();
    a.wait(function(){count++;},0.6);
    a.run();
    return u.add(isEqual(2,count));
  }*/
  /*public function test_arrowlet_in_thread_scheduler(u:TestCase):TestCase{
    var a = function(u:Unit,cont:Unit->Void):Void{
      hx.Timer.wait(
        function(){
          cont(Unit);
        }
      ,3);
    }
    var sch = inject(hx.ifs.Scheduler);
    sch.immediate(a);
    sch.run();
    return u;
  }*/
}

