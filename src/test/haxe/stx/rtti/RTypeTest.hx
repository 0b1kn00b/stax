package stx.rtti;

using stx.Option;

import stx.Muster;
import stx.Muster.*;
import stx.Log.*;

import stx.rtti.*;
import stx.rtti.Introspect;

using stx.rtti.RTypes;

class RTypeTest extends TestCase{
  public function testRType(u:UnitArrow):UnitArrow{
  /*  RTypeTest.typetree()
      .flatMap(TypeTrees.classdef)
      .flatMap(Classdefs.ancestors);*/

    return u;
  }
  public function test_RClass_generates_valid_fields_on_reflector_with_recursive_switch(u:UnitArrow):UnitArrow{
    var a = new RTypeTestClass2();
    var b = a.introspect().reflector(true);
    trace(b);
    return u;
  }
}
@:rtti class RTypeTestClass extends DefaultIntrospect{
  public function new(){super();}
  public var a : String;
}
@:rtti class RTypeTestClass2 extends RTypeTestClass{
  public var b : String;
}