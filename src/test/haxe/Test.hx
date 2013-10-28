using stx.UnitTest;

import Stax.*;
import stx.Log.*;

import stx.ds.Foldables;

class Test{
  function new(){
    trace(debug('entry point'));
    Stax.init();//bootstrap bug 
    trace('here');
    var rig                     = UnitTest.rig();
    var tests : Array<TestCase> = 
    //#if development
      [
        new hx.sch.TaskTest(),
        //new stx.ContinuationTest(),
        //new stx.rct.DefaultReactorTest(),
        /*
        new stx.UnitTestTest(),  
        new stx.TimeTest(),
        new stx.rx.RxTest(),
        new stx.ObjectsTest(),
        new stx.plus.MetaTest(),
        new stx.PositionsTest(),
        new stx.LogTest(),
        new stx.log.prs.LogListingParserTest(),
        new stx.ds.LispListTest(),
        new stx.OutcomeTest(),
        new stx.ArrowTest(),
        new stx.ds.MapTest(),
        new stx.ds.SetTest(),
        new stx.PartialFunctionTest(),
        new stx.plus.OrderTest(),
        new stx.ds.LispListTest(),
        new stx.MapsTest(),
        new hx.ds.PriorityQueueTest(),
              
        new stx.ioc.IocTest(),
        new stx.ReflectsTest(),
        new stx.TypesTest(),
        new stx.ds.ListNewTest(),
        new stx.mcr.SelfTest(),new SubclassTest(),
        new stx.math.geom.Point2dTest(),
        new stx.ds.ZipperTest(),
        new stx.plus.HashTest(),
        new stx.ArraysTest(),
        new stx.plus.CloneTest(),
        
        */
  /*      
        new stx.PredicatesTest(),*/
        //new stx.EventualTest(),
        //new stx.ds.ListTest(),
        //new stx.ds.LinkTest(),
        /*

        new stx.mcr.MacrosTest(),
        new stx.ReturnTest(),
        new stx.MethodTest(),
        new stx.rtti.IntrospectTest(),
        new stx.ErrorTest(),
        
        new stx.ifs.MonadTest(),
        new stx.rtti.RTypeTest(),
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
