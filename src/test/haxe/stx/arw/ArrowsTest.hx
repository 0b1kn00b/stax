package stx.arw;

import haxe.Timer;

import stx.Prelude;
import stx.test.TestCase;
import stx.Tuples.*;

using stx.Tuples;
using stx.Future;
using stx.test.Assert;
using stx.arw.Arrows;
using stx.Log;
using stx.Functions;

using stx.Method;
import stx.arw.Arrows.Arrow.*;
using stx.arw.Arrows;
import stx.arw.*;

class ArrowsTest extends TestCase{

  public function new() {
    super();
  }
  public function testLift() {  
      arr().then(
        function(x:Tuple2<String,String>){
          return x;
        }
      ).then(autoLiftMultipleArguments).apply(tuple2('hello','world'));
  }
  public function autoLiftMultipleArguments(a:String,b:String):String{
    return '$a $b';
  }
  public function autoLiftMultipleArgumentsToFuture(a:String,b:String):Future<String>{
    return Future.pure('$a $b');
  }
}