package stx;

import stx.Log.*;
import stx.Muster;
import stx.Muster.*;

using stx.Method;

class MethodTest extends TestCase{
  public function testConstruct(u:UnitArrow):UnitArrow{
    var a : Method<Int,Int> = function(x:Int):Int {
      trace(x);
      return x;
    }
    $type(a);
    var b = function(x:Int):Int{ 
      trace(x);
      return x + 3;
    };
    trace( a.apply(2) );
    trace( a.then(b).apply(1) );

    return u;
  }
}