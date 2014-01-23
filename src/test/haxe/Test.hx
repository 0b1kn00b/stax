import stx.io.Log.*;

using stx.UnitTest;

import stx.io.Log.*;
import stx.io.log.Logger;
import stx.io.log.logger.HttpLogger;
import stx.ioc.Inject.*;
import stx.*;

import Stax.*;

class Test{
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
    trace('entry point');
    #if flash
        flash.system.Security.allowDomain('*');
    #end
    Stax.init();//bootstrap bug 
    #if flash
        /*var logger = new HttpLogger();
        injector().unbind(Logger);
        injector().bind(Logger,logger);*/
    #end

    var rig                     = UnitTest.rig();
    var tests : Array<Suite> = 
    [
        //new stx.ReaderTest(),
        new stx.ds.LinkTest(),
    ];
    var tests : Array<Suite> = 
    [
        new stx.ArraysTest(),
        new stx.BoolsTest(),
        new stx.CloneTest(),
        new stx.ContractTest(),
        new stx.DatesTest(),
        new stx.EqualTest(),
        new stx.HashTest(),
        new stx.IntIterTest(),
        new stx.MapsTest(),
        new stx.MathsTest(),
        new stx.MetaTest(),
        new stx.MethodTest(),
        new stx.ObjectsTest(),
        new stx.OrderTest(),
        new stx.OutcomeTest(),
        new stx.PartialFunctionTest(),
        new stx.PositionsTest(),
        new stx.PredicatesTest(),
        new stx.ReflectsTest(),
        new stx.ShowTest(),
        new stx.StateTest(),
        new stx.TimeTest(),
        new stx.TupleTest(),
        new stx.TypesTest(),
        /*,
        new HaxeTest(),
        ,
        */

        //new stx.ds.MapTest(),
        

        #if flash9
            //new stx.async.arrowlet.avm2.EventTest(),
        #end
        /*
        new stx.UnitTestTest(), 
        new stx.ces.CESTest(),
        
        new stx.reactive.ObservableTest(),
        
        new stx.async.FutureTest(),
        new stx.async.ArrowletTest(),
        new hx.scheduler.SchedulerTest(),
        new stx.io.LogTest(),
        new rx.RxTest(),    
        
        new hx.reactive.ReactorTest(),
        new stx.UnitTestTest(),
        new stx.TimeTest(),
        
        
        new stx.MonoidTest(),
        new stx.async.ContinuationTest(),
        
        new hx.reactive.DispatchersTest(),
        new stx.utl.SelectorTest(),
                
        new stx.StateTest(),
        new stx.PositionsTest(),
        
                
        new stx.log.prs.LogListingParserTest(),
        new hx.scheduler.TaskTest(),
        

        new stx.mcr.TypesTest(),
        new stx.prs.JsonTest(),
        
        
        new stx.ObjectsTest(),
        new stx.MetaTest(),
        
        new stx.OutcomeTest(),
        new stx.ds.SetTest(),
        new stx.PartialFunctionTest(),
        new stx.OrderTest(),
        new stx.ds.LispListTest(),
        new stx.MapsTest(),
        new hx.ds.PriorityQueueTest(),
              
        new stx.ioc.IocTest(),
        new stx.TypesTest(),    
        new stx.ds.ListNewTest(),
        new SubclassTest(),
        new stx.math.geom.Point2dTest(),
        new stx.ds.ZipperTest(),
        new stx.HashTest(),
        new stx.CloneTest(),
        
        new stx.PredicatesTest(),
        new stx.async.EventualTest(),
        new stx.ds.ListTest(),
        


        new stx.mcr.MacrosTest(),
        new stx.MethodTest(),
        new stx.rtti.IntrospectTest(),
        
        new stx.rtti.RTypeTest(),*/
      ];/*.filter(
        Std.is.bind(_,stx.async.ArrowletTest)
       ); */
    var name = #if select 'devtest' #else 'test' #end;
    rig.append(tests,name).run();
  }
  static public function main(){
    var app = new Test();
  }
}
