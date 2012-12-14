package stx;

/**
 * ...
 * @author 0b1kn00b
 */                 
using stx.Prelude;

import stx.test.TestCase;
import stx.test.Assert;             using stx.test.Assert;

import stx.Future;                 using stx.Future;
using stx.Promises;
import stx.Maths;                   using stx.Maths;
import stx.Iterables;               using stx.Iterables;

class PromiseTest extends TestCase{
  public function new() {
    super();
  }
  /**
  * Resolve Right of Future (success)
  */
  public function testRight() {
    var a = new Future();
    a.foreachR( 
        function(x:String) {
          x.equals('ok');
        }
    );
    a.right('ok');
  }
  /**
  * Map success to value.
  */
  public function testMap() {
    var a = Promises.success('ok');
        a.mapR(
            function(x:String) {
              return 3;
            }
        ).foreachR(
            function(y:Int) {
              3.equals(y);
            }
        );
  }
  /*
  * Flatmap chain
  */
  public function testFlatMap() {
    var a = Promises.success('ok');
        a.flatMapR(
            function(x) {
              'ok'.equals(x);
              return  Promises.success('yup');
            }
        ).foreachR(
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
              return Promises.success(int);
            }
        ).toArray().wait()
         .mapR(
            function(arr) {
              return arr.foldl(               
                0,
                function(int1:Int, int2:Int) {
                  return int1 + int2;
                }
              );
            }
         ).foreachR(
            function(total) {
              45.equals(total);
            }
        );
  }
  /**
  * Test simple error handler
  */
  public function testFutureFailure() {
    var outcome2 = new Future().left('notok')
        .foreachL(
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
    var outcome2 = new Future();
    
    haxe.Timer.delay(
        function() {
          outcome2.left('notok');
        },10
    );
    
    outcome2
        .foreachL(
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
    var outcome = new Future();
    
    haxe.Timer.delay(
        function() {
          outcome.left('not ok1');
        }
        ,10
    );
    
    outcome
        .map(
            function(x) {
              return x;
            }
        ).foreachL(
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
    var outcome = new Future();
    
    haxe.Timer.delay(
        function() {
          outcome.right('ok1');
        }
        ,10
    );
    
    outcome
        .flatMap(
            function (x) {
              return  Promises.failure('false');
            }
        ).foreachL(
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
    var outcome = new Future().right('ok1');
  
    outcome
        .flatMap(
            function (x) {
              return  Promises.failure('false');
            }
        ).map(
            function(x) {
              return x;
            }
        ).foreachL(
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
    var outcome1 = Promises.success('ok1');
    var outcome2 = new Future().left('notok');
    

    [outcome1, outcome2].wait()
    .mapR(
        function (x) {
          return x;
        }
    ).foreachL(
        function(x) {
          true.isTrue();
        }
    ).foreachR(
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
    var outcome1 = Promises.failure('ok1');
    var outcome2 = new Future();
    haxe.Timer.delay(
        function() {
          outcome2.left('notok');
        }
        ,10
    );
    
    [outcome2, outcome1].wait()
    .foreachL(
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
    var outcome0 = Promises.success('ok0');
    var outcome1 = Promises.success('ok1');
    var outcome2 = new Future().left('notok0');
    var outcome3 = new Future().left('notok again');
    var outcome4 = new Future();
    
    haxe.Timer.delay(
        function() {
          outcome4.left('notok');
        }
        ,10
    );
    
    [outcome0, outcome1]
        .waitFor()
        .flatMap(
            function (x){
              return outcome4;
            }
        ).map(
            function(x) {
              return x;
            }
        ).foreachL(
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

    var outcome0 : Future<Either<Dynamic,Dynamic>> 
                  = new stx.Future();

    var outcome1  = Promises.success('ok1');
    var outcome2 : Future<Either<Dynamic,Dynamic>> = new Future();
    var outcome3  = new Future().left('notok again');
    var outcome4  = new Future();
    var outcome5  = new Future().right('ok');
    
    haxe.Timer.delay(
        function() {
          outcome4.left('notok');
        }
        ,10
    );
    haxe.Timer.delay(
        function() {
          outcome2.left('notok 2');
        }
        ,20
    );
    
    var counter = 0;
    
    haxe.Timer.delay(
        function() {
          outcome0.right('ok');
        }
        ,10
    );
    outcome0
        .flatMapR(
            function (x){
              return outcome2;
            }
        ).mapR(
            function(x) {
              return true;
            }
        ).foreachR(
            function(x) {
              Assert.fail();
            }
        ).toCallback(
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
    var outcome1 = Promises.success('ok1');
    var outcome2 = new Future().left('notok');
    var outcome3 = new Future().left('notok again');
    var outcome4 = new Future();
    
    haxe.Timer.delay(
        function() {
          outcome4.right('ok1');
        }
        ,10
    );
    [outcome1, outcome2, outcome3,outcome4]
        .wait()
        .mapR( 
            function(arr) {
              return arr.foldl(
                '',
                    function(a, b) {
                      return a + b;
                    }
              );
            }
        ).foreachL(
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
    var outcome1 = Promises.success('ok1');
    var outcome2 = new Future().left('notok');
    var outcome3 = new Future().left('notok again');
    var outcome4 = new Future();
    var errors   = 4;
    var count    = 0;

    haxe.Timer.delay(
        function() {
          outcome4.right('ok1');
        }
        ,10
    );
    
    [outcome1, outcome2, outcome3,outcome4]
        .wait()
        .foreachL(
            function(x:Dynamic) {
              count++;
              return x;
            }
        ).mapR( 
            function(arr) {
              return arr.foldl(
                '',
                    function(a, b) {
                      return a + b;
                    }
              );
            }
        ).foreachL(
            function(x:Dynamic) {
              count++;
              return x;
            }
        ).flatMapR(
            function(succ) {
              return Promises.failure('');
            }
        ).foreachL(
            function(x:Dynamic) {
              count++;
              return x;
            }
        ).mapR(
            function(x) {
              return x;
            }
        ).foreachL(
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
    var outcome1 = Promises.success('ok1');
    var outcome4 = new Future();
    var errors   = 2;
    var count    = 0;
    haxe.Timer.delay(
        function() {
          outcome4.right('ok1');
        }
        ,10
    );
    
    [outcome1, outcome4]
        .wait()
        .foreachR(
            function(x:Dynamic) {
              return x;
            }
        ).mapR( 
            function(arr) {
              return arr.foldl(
                '',
                    function(a, b) {
                      return a + b;
                    }
              );
            }
        ).foreachR(
            function(x:Dynamic) {
              return x;
            }
        ).flatMapR(
            function(succ) {
              return Promises.failure('');
            }
        ).foreachL(
            function(x:Dynamic) {
              count++;
              return x;
            }
        ).mapR(
            function(x) {
              return x;
            }
        ).foreachL(
            function(x:Dynamic) {
              count++;
              Assert.equals( count , errors );
              true.isTrue();
              async();
              return x;
            }
        );
  }
}