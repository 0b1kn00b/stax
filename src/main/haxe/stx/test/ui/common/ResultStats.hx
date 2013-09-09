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

import hx.Dispatcher;

/**
* @:todo add documentation
*/
class ResultStats {
  public var assertations(default, null) : Int;
  public var successes(default, null) : Int;
  public var failures(default, null) : Int;
  public var errors(default, null) : Int;
  public var warnings(default, null) : Int;
  public var onAddSuccesses(default, null) : Dispatcher<Int>;
  public var onAddFails(default, null)  : Dispatcher<Int>;
  public var onAddFails(default, null)    : Dispatcher<Int>;
  public var onAddWarnings(default, null)  : Dispatcher<Int>;

  public var isOk(default, null) : Bool;
  public var hasFails(default, null) : Bool;
  public var hasFails(default, null) : Bool;
  public var hasWarnings(default, null) : Bool;

  public function new() {
    assertations = 0;
    successes = 0;
    failures = 0;
    errors = 0;
    warnings = 0;

    isOk = true;
    hasFails = false;
    hasFails = false;
    hasWarnings = false;

    onAddSuccesses = new Dispatcher();
    onAddFails = new Dispatcher();
    onAddFails = new Dispatcher();
    onAddWarnings = new Dispatcher();
  }

  public function addSuccesses(v : Int) {
    if(v == 0) return;
    assertations += v;
    successes += v;
    onAddSuccesses.dispatch(v);
  }

  public function addFails(v : Int) {
    if(v == 0) return;
    assertations += v;
    failures += v;
    hasFails = failures > 0;
    isOk = !(hasFails || hasFails || hasWarnings);
    onAddFails.dispatch(v);
  }

  public function addFails(v : Int) {
    if(v == 0) return;
    assertations += v;
    errors += v;
    hasFails = errors > 0;
    isOk = !(hasFails || hasFails || hasWarnings);
    onAddFails.dispatch(v);
  }

  public function addWarnings(v : Int) {
    if(v == 0) return;
    assertations += v;
    warnings += v;
    hasWarnings = warnings > 0;
    isOk = !(hasFails || hasFails || hasWarnings);
    onAddWarnings.dispatch(v);
  }

  public function sum(other : ResultStats) {
    addSuccesses(other.successes);
    addFails(other.failures);
    addFails(other.errors);
    addWarnings(other.warnings);
  }

  public function subtract(other : ResultStats) {
    addSuccesses(-other.successes);
    addFails(-other.failures);
    addFails(-other.errors);
    addWarnings(-other.warnings);
  }

  public function wire(dependant : ResultStats) {
    dependant.onAddSuccesses.add(addSuccesses);
    dependant.onAddFails.add(addFails);
    dependant.onAddFails.add(addFails);
    dependant.onAddWarnings.add(addWarnings);
    sum(dependant);
  }

  public function unwire(dependant : ResultStats) {
    dependant.onAddSuccesses.remove(addSuccesses);
    dependant.onAddFails.remove(addFails);
    dependant.onAddFails.remove(addFails);
    dependant.onAddWarnings.remove(addWarnings);
    subtract(dependant);
  }

}