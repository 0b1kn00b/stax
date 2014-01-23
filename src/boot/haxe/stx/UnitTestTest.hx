package stx;

using haxe.unit.TestCases;

import stx.ioc.Inject.*;
import hx.ifs.Scheduler;
import stx.rtti.Routine;

import Stax.*;
import Prelude;

using stx.Functions;

import stx.reactive.Observer;
import stx.async.Future;
import stx.async.Eventual;
import stx.test.TestResult;
import stx.test.Proof;
import stx.test.TestRig;
import stx.test.TestConstruct;
import stx.UnitTest;

using stx.async.Arrowlet;
using stx.Option;
import haxe.unit.TestCase;


class UnitTestTest extends TestCase{
  private var scheduler : Scheduler;

  public function new(){
    super();
    scheduler = inject(Scheduler);
  }
  public function testTest(){
    var a = UnitTest.rig();
        a = a.add(new Tests());
        a.run();
  }
  public function testTestConstruct(){
    var suite = new Tests();
    var c     = new TestConstruct(suite);
    var d     = [];
    c.reply().subscribe(Observer.create(d.push));
    //trace(d);
  }
  public function testParse(){
    var a = UnitTest.rig();
    var suite = new Tests();
    var c = new TestConstruct(suite);
    var b = TestConstruct.parse(suite);
    isEqual(['testEmpty','testSuccess','testFailure','testHangingTest'],b);
  }
  public function testTestCase(){
    var a = new stx.UnitTest.TestCase();
        a.proceed([]).each(function(x) trace(x));
  }
/*  public function testInvoke(){
  }*/
  /*public function testProof(){
    var bool = false;
    var a = Proof.unit().val(None);
        a.apply(new stx.test.TestResult()).each(function(x) bool = true);
    assertTrue(bool);
  }
  public function testTestCase(){
    var bool = false;
    var a = stx.TestCase.unit();
        a.apply(null).each(
          function(x){
            bool = true;
          }
        );
    assertTrue(bool);
  }*/
}
private class Tests extends Suite{
  public function testEmpty(u:stx.TestCase){
    return u;
  }
  public function testSuccess(u:stx.TestCase){
    return u.add(isTrue(true));
  }
  public function testFailure(u:stx.TestCase){
    return u.add(isTrue(false));
  }
  public function testHangingTest(u:stx.TestCase){
    var a = new Eventual();
    return u.add(a);
  }
}