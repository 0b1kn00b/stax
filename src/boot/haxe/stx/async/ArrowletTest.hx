package stx.async;

import Stax.*;
import haxe.unit.TestCase;

using stx.async.Arrowlet;

class ArrowletTest extends TestCase{
  public function testArrowlet(){
    var a : Arrowlet<Int,Int> = function(x) {return x+1;}
    var val = 0;
    a.apply(1).each(function(x:Int) val = x);
    assertEquals(2,val);
  }
}