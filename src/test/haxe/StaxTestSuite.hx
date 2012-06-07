/*
 HaXe library written by John A. De Goes <john@socialmedia.com>
 Contributed by Social Media Networks

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the
 distribution.

 THIS SOFTWARE IS PROVIDED BY SOCIAL MEDIA NETWORKS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL SOCIAL MEDIA NETWORKS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
import PreludeTest;
																																using Stax;
import stx.functional.FoldableExtensionsTestCase;

import stx.Prelude;

import stx.test.Runner;
import stx.test.ui.Report;
                   
import stx.io.json.JsonTestCase;        
import stx.ds.ArrayExtensionsTestCase;
import stx.ds.MapTestCase;
import stx.ds.SetTestCase;
import stx.ds.ListTestCase;
import stx.io.json.JValueTestCase;
import stx.functional.PartialFunctionTestCase;         
import stx.functional.FoldableExtensionsTestCase;
import stx.time.ScheduledExecutorTestCase;
import stx.net.UrlExtensionsTestCase;
import stx.net.HttpHeaderExtensionsTestCase;
import stx.reactive.ReactiveTestCase;
//import stx.reactive.ReactiveTester;
import stx.util.StringExtensionsTestCase;
import stx.util.GuidTestCase;
import stx.util.ObjectExtensionsTestCase;
import stx.util.OrderExtensionsTestCase;
import stx.framework.InjectorTestCase;
import stx.math.geom.PointTestCase;
import stx.math.tween.TweenTestCase;
import stx.io.json.TranscodeJValueExtensionsTestCase;

import stx.time.ScheduledExecutor;
import stx.framework.Injector;
import stx.Log;

#if js
import stx.io.http.HttpStringTestCase;

import js.dom.HTMLElementExtensionsTestCase;
import js.dom.HTMLDocumentExtensionsTestCase;
import js.dom.QuirksTestCase;
import js.io.IFrameIOTestCase;
import stx.io.http.HttpJValueJsonpTestCase;

using stx.Functions;
import stx.js.Dom;
import stx.js.Env;
#end

class StaxTestSuite {
  public static function main (): Void {
    #if js
      new StaxTestSuite();
    #else
      new StaxTestSuite();
    #end 

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

        haxe.Log.trace = stx.Log.trace;
        var runner = (new Runner()).addAll([   
          new PreludeTest(),    
          new JValueTestCase(),   
          new ArraysTestCase(),
          new MapTestCase(),
          new SetTestCase(),
          new ListTestCase(),
          new JsonTestCase(),   
          new FoldableExtensionsTestCase(),
          new PartialFunctionTestCase(),   
          new TweenTestCase(),
#if !(neko || php || cpp)  
          new ScheduledExecutorTestCase(),
#end
          new UrlExtensionsTestCase(),   
          new ReactiveTestCase(),
          //new ReactiveTester(),
          new StringExtensionsTestCase(),
          new InjectorTestCase(),
          new HttpHeaderExtensionsTestCase(),
          new PointTestCase(),
          new OrderExtensionsTestCase(),
          new GuidTestCase()
          #if js
          , new HttpStringTestCase() // This one should be cross-platform, eventually
          , new IFrameIOTestCase()      
          , new HttpJValueJsonpTestCase()
          , new HTMLElementExtensionsTestCase()
          , new HTMLDocumentExtensionsTestCase()
          , new QuirksTestCase()
          , new ObjectsTestCase()
          , new TranscodeJValueExtensionsTestCase()
          //, new stx.OutcomeTest()
          //, new stx.error.ErrorTest()
          //, new stx.reactive.ArrowsTest()
          , new stx.TupleTest()
          //, new stx.io.log.LogTest()
          , new stx.ds.RangeTest()
          #end
        ]);//.filter( function(x) return Std.is(x, stx.io.log.LogTest) ));

        Report.create(runner);

        runner.run();
        
        return Unit;
      }
    );
  }
}
