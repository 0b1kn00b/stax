package stx;

import stx.Method;

import stx.test.TestCase;
import stx.test.Assert;

import stx.Continuations;

class ContinuationTest extends TestCase{
  public function testCC(){
    var a = function(x,y){return x + y;};
    var b = function(x,y){return x * y;};
  }
}