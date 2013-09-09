import stx.Muster;
import stx.Log.*;

import stx.ds.Foldables;

class Test{
  function new(){
    var rig                     = new TestRig();
    var tests : Array<TestCase> = [
      new stx.ioc.IocTest(),
      new stx.ReflectsTest(),
      new stx.TypesTest(),
      //new stx.ds.ListNewTest(),
      new stx.mcr.SelfTest(),
      /*new SubclassTest(),
      new stx.math.geom.Point2dTest(),
      new stx.ds.ZipperTest(),
      new stx.plus.HashTest(),
      new stx.ArraysTest(),
      new stx.plus.CloneTest(),
      new stx.ObjectsTest(),
      */
/*      
      new stx.PredicatesTest(),*/
      //new stx.EventualTest(),
      //new stx.ds.ListTest(),
      //new stx.ds.LinkTest(),
      /*

      new stx.mcr.MacrosTest(),
      new stx.ArrowsTest(),
      new stx.LogTest(),
      new stx.ContinuationTest(),
      new stx.ReturnTest(),
      new stx.MethodTest(),
      new stx.rtti.IntrospectTest(),
      new stx.ErrorTest(),
      
      new stx.ifs.MonadTest(),
      new stx.rtti.RTypeTest(),
      new stx.PartialFunctionTest()
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
