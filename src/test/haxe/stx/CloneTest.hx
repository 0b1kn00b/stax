package stx;

import haxe.ds.IntMap;

using stx.UnitTest;

import stx.Compare.*;
import stx.io.Log.*;

using stx.Maths;

import stx.Clone;

class CloneTest extends Suite{
  /**
    Type.getInstanceFields is redundant (I think).
  */
  /*public function test_that_extra_reflected_fields_can_show_up_in_classes(u:TestCase):TestCase{
    var a = new BothReflectedFieldsAndTypeFieldsTest();
        a.b = 'c';
    var t = Type.getClass(a);
    var b = Type.getInstanceFields(t);
    var c = Reflect.fields(a);
    return u.add(
      it('should not be equal',
      eq(b).not(),
      c)
    );
  }*/
  public function testClone(u:TestCase):TestCase{
    var a     = new CloneTestClass();
    var b     = Clone.getCloneFor(a)(a,[]);
    var tst1  = a == b;

    var tsts = [];

    tsts.push(isEqual(a,a));
    tsts.push(isTrue(Equal.getEqualFor(a)(a,b)));
    
    tsts.push(isFalse(a==b));
    tsts.push(isEqual(a.cln.inner,b.cln.inner));

    b.cln.inner = 'nef erf';
    tsts.push(isNotEqual(a.cln.inner,b.cln.inner));

    return u.append(tsts);
  }
/*  public function testClone2(u:TestCase):TestCase{
    var a     = new CloneTest2();
    var b     = Clone.getCloneFor(a)(cast a,[]);
    var tsts  = [];

    tsts.push(isEqual(a.cln.inner,b.cln.inner));
    b.cln.inner = 'nef erf';
    tsts.push(isNotEqual(a.cln.inner,b.cln.inner));

    return u.append(tsts);
  }*/
}
private class BothReflectedFieldsAndTypeFieldsTest implements Dynamic{
  public var a : String;
  public function new(){
    this.a = 'b';
  }
}
private typedef Moot = {
  var a : String;
  var b : Int;
  @:optional var c : Date;
  @:optional var d : Moot;
}
private class CloneTestClass{
  public var test : Moot;
  public var cln  : CloneTestInner;

  public function new(){
    test = {
      a : 'hello',
      b : 1,
      c : Date.now()
    }  
    test.d      = test;
    this.cln    = new CloneTestInner();
  }
}
private class CloneTest2{
  public function new(){
    cln = new CloneTestInner();
  }
  public var cln  : CloneTestInner;
}
private class CloneTestInner{
  public var inner : String;
  public function new(){
    this.inner =  'well, heloooo';
  }
}