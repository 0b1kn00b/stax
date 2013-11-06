package hx.rct;

using stx.UnitTest;

import hx.Reactor;

import Prelude;
import stx.Eventual;

import stx.Log.*;

import stx.Enums;
import stx.utl.Selector;

using stx.Compare;
using stx.Tuples;
using stx.Arrays;
using stx.Arrow;

import kwv.rct.*;

enum TestEvent{
  EventVal(v:Int);
  OtherEventVal(v:Int);
}
class ReactorTest extends TestCase{
  public function test_that_once_works_and_that_all_events_can_be_caught(u:UnitArrow):UnitArrow{
    var ev  = Eventual.unit();
    var ev1 = Eventual.unit();
    var a   = new DefaultReactor();
        a.once(new Selector(tuple2(cast Enums.alike,EventVal(999))),
          function(evt){
            ev.deliver(
              isTrue(true)
            );
          }
        );
        a.on(new Selector(tuple2(cast Enums.alike, OtherEventVal(1))),
          function(evt){
            ev1.deliver(
              isTrue(true)
            );
          }
        );
    var ev2 = Eventual.unit();
    var cnt = 0;
        a.on(Reactors.any(),
          function(x){
            cnt++;
            if(cnt == 3){
              ev2.deliver(
                isTrue(true)
              );
            }
          }
        );
        a.emit(EventVal(999));
        a.emit(EventVal(999));
        a.emit(OtherEventVal(1));        
    return u.append([ev,ev1,ev2].map(MusterEventuals.flatten));
  }
  /*public function testLazyStream(u:UnitArrow):UnitArrow{
    var a   = new DefaultReactor();
    var str = a.push();

    a.emit(EventVal(1));
    return u;
  }*/
  /*public function testMergeProperties(u:UnitArrow):UnitArrow{
    var a   = new DefaultReactor();
    var b   = new DefaultReactor();

    var c   = a.push();
    var d   = b.push();

    var e   = c.merge(d);//merge the to pushes
    var f   = e.map(function(x) return x+100);//do something with each
    var g   = LazyStream.enumerate([8,9,10,11,12,13]);//enumerate this array;
    var h   = f.merge(g);//do both(first come, first serve)

    //chunk into collections of 6
    var i   = h.chunk([],
      function(memo,next){
        memo = memo.add(next);
        return if(memo.length == 6){
          Done(memo);
        }else{
          Cont(memo);
        }
      }
    );

    //flatten by enumerating the arrays
    var j  = 
      i.flatMap(
        LazyStream.enumerate
      );

    //don't like this one.
    var k = 
      j.filter(
        function(x){
          return x!=101;
        }
      );

    k.each(
      function(x){

      }
    ).run();

    a.emit(1);
    a.emit(2);
    b.emit(3);    
    b.emit(4);    
    a.emit(5);
    a.emit(6);    

    return u;
  }*/
}

