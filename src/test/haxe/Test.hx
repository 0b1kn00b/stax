import stx.Log.*;

using stx.UnitTest;
import stx.*;

import Stax.*;

class Test{
  @:bug('#0b1kn00b: UnitTest currently relies on rtti which is empty at macro time.')
  macro static function macros(e:Expr){
  /*  var rig                     = UnitTest.rig();
      var tests : Array<Suite> = 
      [
        new stx.mcr.TypesTest(),
      ];
      rig.append(tests#if select ,'devtest' #end).run();*/
    return e;
  }
  function new(){
    trace(debug('entry point'));
    Stax.init();//bootstrap bug 
    var rig                     = UnitTest.rig();
    var tests : Array<Suite> = 

    //#if development
    [
        new rx.RxTest(),    
        /*  
        new stx.UnitTestTest(),
        new stx.StaxTest(),
        new stx.mcr.LensesMacroTest(),
        new stx.mcr.LensesMacroTest(),
        

        new stx.LogTest(),   
        new hx.rct.ReactorTest(),
        new stx.UnitTestTest(),
        new stx.TimeTest(),

        new stx.ArrowletTest(),
        
        
        new stx.ds.MapTest(),
        new HaxeTest(),
        new stx.MonoidTest(),
        new stx.ContinuationTest(),
        
        new hx.rct.DispatchersTest(),
        new stx.utl.SelectorTest(),
                
        new stx.plus.CloneTest(),
        new stx.StateTest(),
        new stx.PositionsTest(),
        
        
        
        new stx.log.prs.LogListingParserTest(),
        new hx.sch.TaskTest(),
        

        new stx.mcr.TypesTest(),
        new stx.prs.JsonTest(),
        
        
        
        new stx.ObjectsTest(),
        new stx.plus.MetaTest(),
        
        new stx.OutcomeTest(),
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
        new SubclassTest(),
        new stx.math.geom.Point2dTest(),
        new stx.ds.ZipperTest(),
        new stx.plus.HashTest(),
        new stx.ArraysTest(),
        new stx.plus.CloneTest(),
        
        new stx.PredicatesTest(),
        new stx.EventualTest(),
        new stx.ds.ListTest(),
        new stx.ds.LinkTest(),


        new stx.mcr.MacrosTest(),
        new stx.MethodTest(),
        new stx.rtti.IntrospectTest(),
        
        new stx.rtti.RTypeTest(),
        */
      ];
    rig.append(tests#if select ,'devtest' #end).run();
  }
  static public function main(){
    var app = new Test();
  }
}
