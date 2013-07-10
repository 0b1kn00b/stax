import stx.Muster;
import stx.Muster.Test.*;
import stx.Log.*;

class Test{
  function new(){
    var rig                     = new TestRig();
    var tests : Array<TestCase> = [
      new stx.rtti.IntrospectTest(),
      /*
      new stx.ErrorTest(),
      new stx.arw.ArrowsTest(),
      new stx.LogTest(),
      new stx.rtti.RTypeTest(),
      new stx.PartialFunctionTest()
      new stx.ds.ListNewTest()
      new stx.ifs.IdentityTest(),
      new stx.ifs.PureTest(),
      new stx.ifs.SemiGroupTest()*/
    ];
    rig.append(tests).run();
  }
  static public function main(){
    var app = new Test();
  }
}
