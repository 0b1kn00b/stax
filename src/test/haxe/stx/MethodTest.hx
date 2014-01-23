package stx;

import stx.io.Log.*;
using stx.UnitTest;

using stx.Method;

class MethodTest extends Suite{
  public function testConstruct(u:TestCase):TestCase{
    var a : Method<Int,Int> = function(x:Int):Int {
      trace(x);
      return x;
    }
    var b = function(x:Int):Int{ 
      trace(x);
      return x + 3;
    };
    trace( a.apply(2) );
    trace( a.then(b).apply(1) );

    return u;
  }
}