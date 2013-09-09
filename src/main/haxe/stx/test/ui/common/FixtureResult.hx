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
package stx.test.ui.common;

import stx.test.Assertation;

/**
* @:todo add documentation
*/
class FixtureResult {
  public var methodName(default, null) : String;
  public var hasTestFail(default, null) : Bool;
  public var hasSetupFail(default, null) : Bool;
  public var hasTeardownFail(default, null) : Bool;
  public var hasTimeoutFail(default, null) : Bool;
  public var hasAsyncFail(default, null) : Bool;

  public var stats(default, null) : ResultStats;

  var list(default, null) : List<Assertation>;
  public function new(methodName : String) {
    this.methodName = methodName;
    this.list = new List();
    hasTestFail = false;
    hasSetupFail = false;
    hasTeardownFail = false;
    hasTimeoutFail = false;
    hasAsyncFail = false;

    stats = new ResultStats();
  }

  public function iterator() {
    return list.iterator();
  }

  public function add(assertation : Assertation) {
    list.add(assertation);
    switch(assertation) {
      case Success(_):
        stats.addSuccesses(1);
      case Fail(_, _):
        stats.addFails(1);
      case Fail(_, _):
        stats.addFails(1);
      case SetupFail(_, _):
        stats.addFails(1);
        hasSetupFail = true;
      case TeardownFail(_, _):
        stats.addFails(1);
        hasTeardownFail = true;
      case TimeoutFail(_, _):
        stats.addFails(1);
        hasTimeoutFail = true;
      case AsyncFail(_, _):
        stats.addFails(1);
        hasAsyncFail = true;
      case Warning(_):
        stats.addWarnings(1);
    }
  }
}