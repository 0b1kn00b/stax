package stx;

using stx.UnitTest;
import stx.Log.*;

using stx.Arrow;
using stx.Eventual;
using stx.Continuation;
using stx.Functions;
using stx.Tuples;

class ContinuationTest extends TestCase{
  public function testCC(u:UnitArrow):UnitArrow{
    //pythagoras(3, 4, printer());
    /*var square = function(x:Int) return x * x;
    var squarec = function(x:Int) return Cont.pure(square(x));
    var out = squarec(2);
    out.apply(printer());*/
    return u;
  }
  function pythagoras(x:Int, y:Int, cont:Int->Void) {
    var x_          = square.bind(x);
    var x_squared   = callcc(x_);

    var x_squared2  = square.bind(x);

    var y_          = square.bind(y);
    var y_squared   = callcc(y_);
    var y_squared2  = square.bind(y);

  }
  function call(x:Int,fn:Int->Cont<Void,Int>):Cont<Void,Int>{
    return fn(x);
  }
  function square(x:Int, cont:Int->Void) {
    multiply(x, x, cont);
  }
  function multiply(x:Int, y:Int, cont:Int->Void) {
    cont(x * y);
  }
  function add(x:Int, y:Int, cont:Int->Void) {
    trace(x);
    cont(x + y);
  }
  function callcc(f:(Int->Void)->Void):Int {
    var val : Int;
    var cc  : Int->Void = null;
        cc = function (x) {
          val = x;
        };
    f(cc);

    return val;
  }
  public function testZip(u:UnitArrow):UnitArrow{
    
    return u;
  }
}