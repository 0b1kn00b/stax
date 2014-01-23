package stx.async.arrowlet.avm2;

import Prelude;
import haxe.Timer;
import flash.events.*;
import flash.events.Event;
import flash.events.Event.*;
import flash.display.Sprite;

using stx.Tuples;
using stx.Functions;
import Stax.*;
import stx.Compare.*;
import stx.io.Log.*;

import stx.test.Proof;
import stx.Selectors.*;

using stx.UnitTest;
using stx.async.Arrowlet;
using stx.async.arrowlet.avm2.Event.Events;

import flash.Lib.*;
import stx.async.arrowlet.avm2.Event in EventA;
using stx.async.arrowlet.Repeat;

class EventTest extends Suite{
  public function testAddEnter(u:TestCase):TestCase{
    var stage                     = current.stage;
    var sprite                    = new Sprite();
    var ev0     : EventA<Event>   = ADDED_TO_STAGE;
    var ev1     : EventA<Event>   = ENTER_FRAME; //abstract type goodness.

    var evt : Proof = ev0
    .tie(
      ev1.first().then(
        function(l:Event,r:Event){
          return l;
        }.tupled()
      )
    ).then(
      function(e:Event){
        return isEqual(e.type,ENTER_FRAME);
      }
    ).apply(sprite);

    stage.addChild(sprite);

    return u.add(evt);
  }  
  public function testProject(u:TestCase):TestCase{
    var stage                     = current.stage;
    var sprite                    = new Sprite();
    var ev0     : EventA<Event>   = ADDED_TO_STAGE;
    var ev1     : EventA<Event>   = ENTER_FRAME;
    var ev2     : EventA<Event>   = REMOVED_FROM_STAGE;


    var ts = 
      ev1
      .then(Timer.stamp.promote())
      .collect(count(3),Arrays.add,[]);//collect three onEnterFram events, timestamp and continue

    var ev3 = ev0.tie(ts.first());
    var ev4 = ev3.split(ev2); //split because add/remove may be synchronous
    var ev5 = ev4.then(function(l:Tuple2<Array<Float>,Event>,r:Event){return tuple3(r,l.fst(),l.snd());}.tupled());
    ev5.project()(sprite).apply(printer());

    stage.addChild(sprite);
    stage.removeChild(sprite);



    return u;
  }
}

