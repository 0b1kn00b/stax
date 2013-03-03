package stx;

/**
 * ...
 * @author 0b1kn00b
 */                 
using stx.Prelude;

import stx.test.TestCase;
import stx.test.Assert;             using stx.test.Assert;

using stx.Future;
using stx.Promise;
using stx.Error;
using stx.Maths;
using stx.Iterables;

class PromiseTest extends TestCase{
  public function new() {
    super();
  }
  /**
  * Resolve Right of Future (success)
  */
  public function testRight() {
    var a = new Promise();
    a.foreach( 
        function(x:String) {
          x.equals('ok');
        }
    );
    a.ok('ok');
  }
  /**
  * Map success to value.
  */
  public function testMap() {
    var a = 'ok'.intact();
        a.map(
            function(x:String) {
              return 3;
            }
        ).foreach(
            function(y:Int) {
              3.equals(y);
            }
        );
  }
  /*
  * Flatmap chain
  */
  public function testFlatMap() {
    var a = 'ok'.intact();
        a.flatMap(
            function(x) {
              'ok'.equals(x);
              return  'yup'.intact();
            }
        ).foreach(
            function(x) {
              'yup'.equals(x);
            }
        );
  }
  /**
  * Test Parallel execution
  */
  public function testFutures(){
    0.until(10)
        .map(
            function(int:Int) {
              return int.intact();
            }
        ).toArray().wait()
         .map(
            function(arr) {
              return arr.foldl(               
                0,
                function(int1:Int, int2:Int) {
                  return int1 + int2;
                }
              );
            }
         ).foreach(
            function(total) {
              45.equals(total);
            }
        );
  }
  /**
  * Test simple error handler
  */
  public function testFutureFailure() {
    var outcome2 = 'notok'.breach()
        .foreach(
            function(x) {
              true.isTrue();
              //['notok', 'notok again'].equals(cast x);
            }
        );
  }
  /**
  * Test asynchronous failure
  */
  public function testFuturesFailure0() {
    var async   = Assert.createAsync( function() { } , 200);
    var outcome2 = new Promise();
    
    haxe.Timer.delay(
        function() {
          outcome2.no('notok'.toError());
        },10
    );
    
    outcome2
        .foreach(
            function(x:Dynamic) {
              true.isTrue();
              async();
              return x;
            }
        );
  }
  /**
  * Test error flow through map
  */
  public function testFuturesFailure2() {
    var async   = Assert.createAsync( function() { } , 200);
    var outcome = new Promise();
    
    haxe.Timer.delay(
        function() {
          outcome.no('not ok1'.toError());
        }
        ,10
    );
    
    outcome
        .map(
            function(x) {
              return x;
            }
        ).failure(
            function(x:Dynamic) {
              true.isTrue();
              async();
              return x;
              //['notok', 'notok again'].equals(cast x);
            }
        );
  }
  /**
  * Test error flow through flatmap
  */
  public function testFuturesFailure3() {
    var async   = Assert.createAsync( function() { } , 200);
    var outcome = new Promise();
    
    haxe.Timer.delay(
        function() {
          outcome.ok('ok1');
        }
        ,10
    );
    
    outcome
        .flatMap(
            function (x) {
              return  'false'.breach();
            }
        ).failure(
            function(x:Dynamic) {
              true.isTrue();
              async();
              return x;
              //['notok', 'notok again'].equals(cast x);
            }
        );
  } 
  /**
  * Test error flow through flatmap and map failing on flatmap
  */
  public function testFuturesFailure4() {
    var async   = Assert.createAsync( function() { } , 200);
    var outcome = 'ok1'.intact();
  
    outcome
        .flatMap(
            function (x) {
              return  'false'.breach();
            }
        ).map(
            function(x) {
              return x;
            }
        ).failure(
            function(x:Dynamic) {
              true.isTrue();
              async();
              return x;
            }
        );
  }
  /**
  * Test error from parallel execution
  */
  public function testWaitFailer10() {
    var outcome1 = 'ok1'.intact();
    var outcome2 = 'notok'.breach();
    

    [outcome1, outcome2].wait()
    .map(
        function (x) {
          return x;
        }
    ).failure(
        function(x) {
          true.isTrue();
        }
    ).foreach(
        function(x) {
          Assert.fail();
        }
    );
  }
  /**
  * Test mixed success / failure result in parallel
  */
    public function testWaitFailer11() {
    var async   = Assert.createAsync( function() { } ,200);
    var outcome1 = 'ok1'.breach();
    var outcome2 = new Promise();
    haxe.Timer.delay(
        function() {
          outcome2.no('notok'.toError());
        }
        ,10
    );
    
    [outcome2, outcome1].wait()
    .failure(
        function(x) {
          true.isTrue();
          async();
        }
    );
  }
  
  /**
  * Test parallel initial success with failure after a flatmap-
  */
  public function testFuturesFailure7() {
    var async   = Assert.createAsync( function() { } ,200);
    var outcome0 = 'ok0'.intact();
    var outcome1 = 'ok1'.intact();
    var outcome2 = 'notok0'.breach();
    var outcome3 = 'notok again'.breach();
    var outcome4 = new Promise();
    
    haxe.Timer.delay(
        function() {
          outcome4.no('notok'.toError());
        }
        ,10
    );
    
    [outcome0, outcome1]
        .wait()
        .flatMap(
            function (x){
              return outcome4;
            }
        ).map(
            function(x) {
              return x;
            }
        ).failure(
            function(x:Dynamic) {
              true.isTrue();
              async();
              return x;
              //['notok', 'notok again'].equals(cast x);
            }
        );
  }
  /**
  * Test error handler flow to callback.
  */
  public function testFuturesFailure8() {
    var async     = Assert.createAsync( function() { } ,200);

    var outcome0  = new Promise();

    var outcome1  = 'ok1'.intact();
    var outcome2  = new Promise();
    var outcome3  = 'notok again'.breach();
    var outcome4  = new Promise();
    var outcome5  = 'ok'.intact();
    
    haxe.Timer.delay(
        function() {
          outcome4.no('notok'.toError());
        }
        ,10
    );
    haxe.Timer.delay(
        function() {
          outcome2.no('notok 2'.toError());
        }
        ,20
    );
    
    var counter = 0;
    
    haxe.Timer.delay(
        function() {
          outcome0.ok('ok');
        }
        ,10
    );
    outcome0
        .flatMap(
            function (x){
              return outcome2;
            }
        ).map(
            function(x) {
              return true;
            }
        ).foreach(
            function(x) {
              Assert.fail();
            }
        ).callback(
            function(err, res) {
              if (err != null) {
                true.isTrue();
                async();
              }
            }
        );
  }
  /**
  * More mixed mode parallel tests
  */
  public function testFuturesFailure6() {
    var async   = Assert.createAsync( function() { } ,200);
    var outcome1 = 'ok1'.intact();
    var outcome2 = 'notok'.breach();
    var outcome3 = 'notok again'.breach();
    var outcome4 = new Promise();
    
    haxe.Timer.delay(
        function() {
          outcome4.ok('ok1');
        }
        ,10
    );
    [outcome1, outcome2, outcome3,outcome4]
        .wait()
        .map( 
            function(arr) {
              return arr.foldl(
                '',
                    function(a, b) {
                      return a + b;
                    }
              );
            }
        ).failure(
            function(x:Dynamic) {
              true.isTrue();
              async();
              return x;
              //['notok', 'notok again'].equals(cast x);
            }
        );
  }
  /**
  * Test complex error handling conditions
  */
  public function testFuturesFailure9() {
    var async   = Assert.createAsync( function() { } , 200);
    var outcome1 = 'ok1'.intact();
    var outcome2 = 'notok'.breach();
    var outcome3 = 'notok again'.breach();
    var outcome4 = new Promise();
    var errors   = 4;
    var count    = 0;

    haxe.Timer.delay(
        function() {
          outcome4.ok('ok1');
        }
        ,10
    );
    
    [outcome1, outcome2, outcome3,outcome4]
        .wait()
        .recover(
            function(x:Dynamic) {
              count++;
              return Right(x);
            }
        ).map( 
            function(arr) {
              return arr.foldl(
                '',
                    function(a, b) {
                      return a + b;
                    }
              );
            }
        ).failure(
            function(x:Dynamic) {
              count++;
              return x;
            }
        ).flatMap(
            function(succ) {
              return ''.breach();
            }
        ).failure(
            function(x:Dynamic) {
              count++;
              return x;
            }
        ).map(
            function(x) {
              return x;
            }
        ).failure(
            function(x:Dynamic) {
              count++;
              true.isTrue();
              Assert.equals( count , errors );
              async();
              return x;
            }
        );
  }
  /**
  * Test complex error handling conditions
  */
  public function testFuturesFailure10() {
    var async   = Assert.createAsync( function() { } , 200);
    var outcome1 = 'ok1'.intact();
    var outcome4 = new Promise();
    var errors   = 2;
    var count    = 0;
    haxe.Timer.delay(
        function() {
          outcome4.ok('ok1');
        }
        ,10
    );
    var ocs : Array<Promise<Dynamic>> = [outcome1, outcome4];
    ocs
        .wait()
        .foreach(
            function(x:Dynamic) {
              return x;
            }
        ).map( 
            function(arr:Array<Dynamic>) {
              return arr.foldl(
                '',
                    function(a, b) {
                      return a + b;
                    }
              );
            }
        ).foreach(
            function(x:Dynamic) {
              return x;
            }
        ).flatMap(
            function(succ) {
              return ''.breach();
            }
        ).failure(
            function(x:Dynamic) {
              count++;
            }
        ).map(
            function(x) {
              return x;
            }
        ).failure(
            function(x:Dynamic) {
              count++;
              Assert.equals( count , errors );
              true.isTrue();
              async();
            }
        );
  }
}