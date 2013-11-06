package stx.mcr;

import stx.Types.*;
using stx.UnitTest;

import Prelude;
import stx.Objects;

import stx.mcr.LensesMacro;

using stx.Lenses;

class LensesMacroTest extends TestCase {
  public function testLense(u:UnitArrow):UnitArrow{

    var v : ABC = {
      a : { 
        something : '1'
      },
      b : {},
      c :
      {
        d : "hello"
      }
    }
    var a = Lenser.lense(TpTest);
    var b = new TpTest();
    /*var c = a.a;
    var d = c.get(b);
    trace(d);
    trace('here');
    $type(a.b);*/
    /*var v0 : F = {
      a : "hello",
    }*/
    //var b = Lenser.lense(v0);
    //Lenser.print(TestLenseEnum.A);
    return u;
  }
}
enum TestLenseEnum{
  A;
  B(ot:String);
  C(arr:Array<String>,?pos:Bool);
}
typedef F = {
  a : String,
}
typedef ABC = {
  public var a : Dynamic;
  public var b : Object;
  public var c : DEF;
}
typedef DEF = {
  public var d : String;
}
