
using stx.Prelude;

import stx.test.Runner;
import stx.test.ui.Report;
import stx.LogLevel;

import stx.Assert;

using stx.framework.Injector;
using stx.Log;

#if type_all
  import AllClasses;
#end

class StaxTestSuite {
  public static function main (): Void {
    new StaxTestSuite();
  }
  public function new(){
      Injector.forever(
      function(c) {
        c.bindF(
          Logger,
          function() {
            return cast DefaultLogger.create(
              null,
              LogLevel.Warning
            );
          }
        );
        var tests =
        [
          new stx.plus.OrderTest(),
            
          new stx.ArraysTest(),
          new stx.ds.MapTest(),
          new stx.ds.SetTest(),
          new stx.ds.ListTest(),
          
          new stx.functional.FoldablesTest(),
          new stx.functional.PartialFunctionTest(),   

          new stx.math.tween.TweensTest(),
#if !(neko || php || cpp || java || cs )  
          new stx.time.ScheduledExecutorTest(),
          new stx.reactive.ReactiveTest(),
#end
          new stx.net.UrlsTest(),   
          new stx.net.HttpHeadersTest(),
          //new ReactiveTester(),
          //new stx.StringsTest(),
          new stx.framework.InjectorTest(),
          new stx.math.geom.PointTest(),
          new stx.util.GuidTest()
#if js
          , new js.io.IFrameIOTest()      
          , new js.dom.HTMLElementsTest()
          , new js.dom.HTMLDocumentsTest()
          , new js.dom.QuirksTestCase()
          , new stx.PromiseTest()//#0b1kn00b how to test delayed easily without timer.
#end
          , new stx.ObjectsTest()
          //, new stx.io.json.TranscodeJValuesTest()          
          //, new stx.io.json.JValueTest()
          //, new stx.io.json.JsonTest()
          //, new stx.io.http.HttpStringTest() // This one should be cross-platform, eventually
          //, new stx.io.http.HttpJValueJsonpTest()
          , new stx.TupleTest()
          , new stx.ds.RangeTest()
          , new stx.MathsTest()
          , new stx.BoolsTest()
#if dev
          //, new StaxTest()
          //, new stx.ErrorTest()
          //, new stx.reactive.ArrowsTest()
          //, new stx.StateTest()
          //, new stx.ReaderTest()
          //, new stx.reactive.StreamTest()
          //, new stx.io.log.LogTest()
          //, new stx.io.FileSystemTest()
          //, new stx.IntIterTest()
          //, new OptimiseTest()
          //, new stx.ds.ZipperTest()
          //, new stx.ds.IterateeTest()
#end
        ]#if dev.filter( function(x) return Std.is(x,stx.BoolsTest) )#end;
        haxe.Log.trace = stx.Log.trace;

        var runner = new Runner();
            runner.addAll(tests #if dev,'test'#end);

        Report.create(runner);

        runner.run();

        return Unit;
      }
    );
  }
}
