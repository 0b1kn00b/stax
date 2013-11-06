package rx;

import hx.rct.DefaultReactor;

import stx.Eventual;
import stx.Chunk;

import stx.rct.*;
import Stax.*;
import stx.Compare.*;
import stx.Log.*;

using stx.Arrays;
using stx.UnitTest;

using rx.Observable;

import rx.Observers;
import rx.observable.BufferedObservable;

class RxTest extends TestCase{
  public function tstRx(u:UnitArrow):UnitArrow{
    var evt = Eventual.unit();
    var obs = [1,2,3,4].map(Val).observe();//no terminating value
    var obs0 = [6,7,8,9].map(Val).observe();//similarly
    var obs1 = obs.concat(obs0);
        //obs1.each(printer()); //produces up to 4, no fu
    var evts = new EventStream();
        //evts.on(Reactors.any(),printer());
    var obs2 = evts.observe();
    var _obs_ = obs2.concat(obs0);
        _obs_.each(printer());
        _obs_.next(printer());
        _obs_.done(
          function(){
            trace('done');
            evt.deliver(isTrue(true));
          }
        );
    /*var a = Observables.returns(1);
        a.each(printer());*/
    return u.add(evt.flatten());
  }
  public function testTake(u:UnitArrow):UnitArrow{
    var obs   = [1,2,3,4].observe();
        obs.takeWhile(function(i) return i < 2).next(printer());
        obs.takeWhile(function(i) return i > 2).next(printer());
        obs.first().next(printer());
        obs.first().next(printer());
    //var obs1  = obs.first();

        /*obs1.each(printer());
        obs1.each(printer());*/
    /*var 3obs2  = [5,6,7,8].observe();
    var obs3  = obs2.takeWhile(eq(Val(8)).not());
    var obs4  = obs1.concat(obs1);*/
        //obs3.next(printer());
        //obs4.next(printer());
    return u;
  }
}
private class EventStream extends DefaultReactor<Chunk<Int>>{
  public function new(){
    super();
    var count = 0;
    var max   = 5;
    var t     = new haxe.Timer(1000);
        t.run = (
          function(){
            if(count<=max){
              emit(Val(count));
            }else{
              emit(Nil);
              t.stop();
            }
            count++;
          }
        );
  }
}