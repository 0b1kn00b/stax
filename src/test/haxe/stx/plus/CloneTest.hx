package stx.plus;

import haxe.ds.IntMap;

import stx.Muster;
import stx.Muster.*;
import stx.Compare.*;
import stx.Log.*;

using stx.Maths;

import stx.plus.Clone;

class CloneTest extends TestCase{
  /**
    Type.getInstanceFields is redundant (I think).
  */
  public function test_that_extra_reflected_fields_can_show_up_in_classes(u:UnitArrow):UnitArrow{
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
  }
  public function testClone(u:UnitArrow):UnitArrow{
    var a     = new CloneTestClass();
    var b     = Clone.getCloneFor(a)(cast a,[]);
    var tst1  = a == b;

    return u.add(
      it('should be equal',
        eq(a),
        b
      )
    ).add(
      it('should not be the same',
        no(),
        tst1
      )
    );
  }
}
class BothReflectedFieldsAndTypeFieldsTest implements Dynamic{
  public var a : String;
  public function new(){
    this.a = 'b';
  }
}
private typedef Moot = {
  var a : String;
  var b : Int;
  var c : Date;
  @:optional var d : Moot;
}
class CloneTestClass{
  public var test : Moot;

  public function new(){
    test = {
      a : 'hello',
      b : 1,
      c : Date.now()
    }  
    test.d = test;
  }
}