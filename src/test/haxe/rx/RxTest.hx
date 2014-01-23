package rx;

import hx.reactive.DefaultReactor;

import stx.async.Eventual;
import stx.Chunk;

import stx.rct.*;
import Stax.*;
import stx.Compare.*;
import stx.io.Log.*;

using stx.Arrays;
using stx.UnitTest;
using stx.reactive.Observable;

import stx.async.Future;
import stx.reactive.Observer;
import stx.reactive.observable.BufferedObservable;

class RxTest extends Suite{
  public function tstRx(u:TestCase):TestCase{
    var evt = Eventual.unit();
    var obs = [1,2,3,4].map(Val).observable();//no terminating value
    var obs0 = [6,7,8,9].map(Val).observable();//similarly
    //var obs1 = obs.concat(obs0);
        //obs1.each(printer()); //produces up to 4, no fu
    //var evts = new EventStream();
        //evts.on(Reactors.any(),printer());
    /*var obs2 = evts.observe();
    var _obs_ = obs2.concat(obs0);
        _obs_.each(printer());
        _obs_.next(printer());
        _obs_.done(
          function(){
            trace('done');
            evt.deliver(isTrue(true));
          }
        );*/
    return u.add(evt);
  }
  public function testTake(u:TestCase):TestCase{
    var obs   = [1,2,3,4].observable();
/*        obs.takeWhile(function(i) return i < 2).next(printer());
        obs.takeWhile(function(i) return i > 2).next(printer());
        obs.first().next(printer());
        obs.first().next(printer());*/
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
    var t     = new hx.Timer(1000);
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