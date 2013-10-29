package hx.sch;

import Type;

import stx.Time;
import stx.Eventual;
import Stax.*;
import stx.Compare.*;
import stx.Log.*;

using stx.Functions;
using stx.Compose;
using stx.UnitTest;

import hx.sch.ThreadScheduler;

import stx.Time.*;
import Sys.*;

import neko.vm.Thread;

class SchedulerTest extends TestCase{
  /*public function test_what_sort_of_messages_threads_can_send(u:UnitArrow):UnitArrow{
    var evt = Eventual.unit();
    var th  = Thread.create(
      function(){
        var tsts = [];
        var o = Thread.readMessage(true);
        tsts.push(isEqual(TClass(String),vtype(o)));
        //o();
        var o2 = Thread.readMessage(true);
        tsts.push(isAlike(TFunction,vtype(o2)));

        evt.deliver(tsts);
      }
    );
    th.sendMessage('one');
    th.sendMessage(function(){ trace('hello'); });
    sleep(0.1);
    return u.then(evt.flatten());
  }*/
/*  public function test_can_i_crash_the_stack(u:UnitArrow):UnitArrow{
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
  }*/
  public function testScheduler(u:UnitArrow):UnitArrow{
    trace(info(Date.now()));

    var evt = Eventual.unit();
    var a = new ThreadScheduler();
        a.now(
          function(){
            trace(info(Date.now()));
          }
        );
        a.wait(2,
          function(){
            trace(info(Date.now()));
          }
        );
        a.wait(20,
          function(){
            trace(info(Date.now()));
            evt.deliver(isTrue(true));
          }
        );
        a.latch();
    return u.add(evt.flatten());
  }
}

