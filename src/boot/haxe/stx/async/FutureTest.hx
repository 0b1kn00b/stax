package stx.async;

import Stax.*;

import haxe.unit.TestCase;

using stx.async.Future;

class FutureTest extends TestCase{
  public function testTimeout(){
    var val = null;
    function(cb:Int->Void){

    }.timeout(thunk(3),3000)
    .apply(
      function(x){
        val = x;
      }
    );
    assertEquals(3,val);
  }
}