/*
 HaXe library written by Franco Ponticelli <franco.ponticelli@gmail.com>

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the
 distribution.

 THIS SOFTWARE IS PROVIDED BY FRANCO PONTICELLI "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL SOCIAL MEDIA NETWORKS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package stx.test.ui.text;

import haxe.PosInfos;
import stx.test.ui.common.IReport;
import stx.test.ui.common.HeaderDisplayMode;

import stx.test.Runner;
import stx.test.TestResult;
import stx.test.ui.common.ResultAggregator;
import stx.test.ui.common.PackageResult;
import haxe.Stack;

using stx.test.ui.common.ReportTools;

/**
* @:todo add documentation
* @:todo default outputhandler
*/
class PlainTextReport implements IReport<PlainTextReport> {
  public var displaySuccessResults : SuccessResultsDisplayMode;
  public var displayHeader : HeaderDisplayMode;
  public var handler : PlainTextReport -> Void;
  
  var aggregator : ResultAggregator;
  var newline : String;
  var indent : String;
  public function new(runner : Runner, ?outputHandler : PlainTextReport -> Void) {
    aggregator = new ResultAggregator(runner, true);
    runner.onStart.add(start);
    aggregator.onComplete.add(complete);
    if (null != outputHandler)
      setHandler(outputHandler);
    displaySuccessResults = AlwaysShowSuccessResults;
    displayHeader = AlwaysShowHeader;
  }
  
  public function setHandler(handler : PlainTextReport -> Void) : Void {
    this.handler = handler;
  }

  var startTime : Float;
  function start(e) {
    startTime = haxe.Timer.stamp();
  }

  function indents(c : Int) {
    var s = '';
    for(_ in 0...c)
      s += indent;
    return s;
  }
  
  function dumpStack(stack : Array<StackItem>) {
    if (stack.length == 0)
      return "";
    
    var parts = Stack.toString(stack).split("\n");
    var r = [];
    for (part in parts) {
      if (part.indexOf(" utest.") >= 0) continue;
      r.push(part);
    }
    return r.join(newline);
  }

  function addHeader(buf : StringBuf, result : PackageResult) {
    if (!this.hasHeader(result.stats))
      return;
    
    var end = haxe.Timer.stamp();
#if php
    var scripttime = Std.int(php.Sys.cpuTime()*1000)/1000;
#end
    var time = Std.int((end-startTime)*1000)/1000;
    
    buf.add("results: " + (result.stats.isOk ? "ALL TESTS OK" : "SOME TESTS FAILURES")+newline+" "+newline);

    buf.add("assertations: "   + result.stats.assertations+newline);
    buf.add("successes: "      + result.stats.successes+newline);
    buf.add("errors: "         + result.stats.errors+newline);
    buf.add("failures: "       + result.stats.failures+newline);
    buf.add("warnings: "       + result.stats.warnings+newline);
    buf.add("execution time: " + time+newline);
#if php
    buf.add("script time: "    + scripttime+newline);
#end
    buf.add(newline);
  }
  
  var result : PackageResult;
  public function getResults() : String {
    var buf = new StringBuf();
    addHeader(buf, result);
    
    for(pname in result.packageNames()) {
      var pack = result.getPackage(pname);
      if (this.skipResult(pack.stats, result.stats.isOk)) continue;
      for(cname in pack.classNames()) {
        var cls = pack.getClass(cname);
        if (this.skipResult(cls.stats, result.stats.isOk)) continue;
        buf.add((pname == '' ? '' : pname+".")+cname+newline);
        for(mname in cls.methodNames()) {
          var fix = cls.get(mname);
          if (this.skipResult(fix.stats, result.stats.isOk)) continue;
          buf.add(indents(1)+mname+": ");
          if(fix.stats.isOk) {
            buf.add("OK ");
          } else if(fix.stats.hasErrors) {
            buf.add("ERROR ");
          } else if(fix.stats.hasFailures) {
            buf.add("FAILURE ");
          } else if(fix.stats.hasWarnings) {
            buf.add("WARNING ");
          }
          var messages = '';
          for(assertation in fix.iterator()) {
            switch(assertation) {
              case Success(pos):
                buf.add('.');
              case Failure(msg, pos):
                buf.add('F');
                messages += indents(2)+"line: " + pos.lineNumber + ", " + msg + newline;
              case Error(e, s):
                buf.add('E');
                messages += indents(2)+ Std.string(e) + dumpStack(s) + newline ;
              case SetupError(e, s):
                buf.add('S');
                messages += indents(2)+ Std.string(e) + dumpStack(s) + newline;
              case TeardownError(e, s):
                buf.add('T');
                messages += indents(2)+ Std.string(e) + dumpStack(s) + newline;
              case TimeoutError(missedAsyncs, s):
                buf.add('O');
                messages += indents(2)+ "missed async calls: " + missedAsyncs + dumpStack(s) + newline;
              case AsyncError(e, s):
                buf.add('A');
                messages += indents(2)+ Std.string(e) + dumpStack(s) + newline;
              case Warning(msg):
                buf.add('W');
                messages += indents(2)+ msg + newline;
            }
          }
          buf.add(newline);
          buf.add(messages);
        }
      }
    }
    return buf.toString();
  }

  function complete(result : PackageResult) {
    this.result = result;
    handler(this);
  }
}