package stx;

/**
 * ...
 * @author 0b1kn00b
 */                 
                                      using Stax;
import stx.test.TestCase;
import stx.test.Assert;             using stx.test.Assert;

import stx.Promise;                 using stx.Promise;
import stx.Maths;                   using stx.Maths;
import stx.Iterables;               using stx.Iterables;
import stx.reactive.Arrows;         using stx.reactive.Arrows;

class PromiseTest extends TestCase{
  public function new() {
    super();
  }
  /**
  * Resolve Right of Promise (success)
  */
  public function testRight() {
    var a = new Promise();
    a.foreach( 
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
    var a = 'ok'.success();
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
    var a = 'ok'.success();
        a.flatMap(
            function(x) {
              'ok'.equals(x);
              return 'yup'.success();
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
  public function testPromises(){
    0.until(10)
        .map(
            function(int:Int) {
              return int.success();
            }
        ).toArray().waitFor()
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
  public function testPromiseFailure() {
    var outcome2 = new Promise().left('notok')
        .onError(
            function(x) {
              true.isTrue();
              return x;
              //['notok', 'notok again'].equals(cast x);
            }.lift()
        );
  }
  /**
  * Test asynchronous failure
  */
  public function testPromisesFailure0() {
    var async   = Assert.createAsync( function() { } , 200);
    var outcome2 = new Promise();
    
    haxe.Timer.delay(
        function() {
          outcome2.left('notok');
        },10
    );
    
    outcome2
        .onError(
            function(x:Dynamic) {
              true.isTrue();
              async();
              return x;
            }.lift()
        );
  }
  /**
  * Test error flow through map
  */
  public function testPromisesFailure2() {
    var async   = Assert.createAsync( function() { } , 200);
    var outcome = new Promise();
    
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
        ).onError(
            function(x:Dynamic) {
              true.isTrue();
              async();
              return x;
              //['notok', 'notok again'].equals(cast x);
            }.lift()
        );
  }
  /**
  * Test error flow through flatmap
  */
  public function testPromisesFailure3() {
    var async   = Assert.createAsync( function() { } , 200);
    var outcome = new Promise();
    
    haxe.Timer.delay(
        function() {
          outcome.right('ok1');
        }
        ,10
    );
    
    outcome
        .flatMap(
            function (x) {
              return Promise.failure('false');
            }
        ).onError(
            function(x:Dynamic) {
              true.isTrue();
              async();
              return x;
              //['notok', 'notok again'].equals(cast x);
            }.lift()
        );
  } 
  /**
  * Test error flow through flatmap and map failing on flatmap
  */
  public function testPromisesFailure4() {
    var async   = Assert.createAsync( function() { } , 200);
    var outcome = new Promise().right('ok1');
  
    outcome
        .flatMap(
            function (x) {
              return Promise.failure('false');
            }
        ).map(
            function(x) {
              return x;
            }
        ).onError(
            function(x:Dynamic) {
              true.isTrue();
              async();
              return x;
            }.lift()
        );
  }
  /**
  * Test error from parallel execution
  */
  public function testWaitFailer10() {
    var outcome1 = 'ok1'.success();
    var outcome2 = new Promise().left('notok');
    
    [outcome1, outcome2].waitFor()
    .map(
        function (x) {
          return x;
        }
    ).onError(
        function(x) {
          true.isTrue();
          return x;
        }.lift()
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
    var outcome1 = 'ok1'.success();
    var outcome2 = new Promise();
    haxe.Timer.delay(
        function() {
          outcome2.left('notok');
        }
        ,10
    );
    
    [outcome2, outcome1].waitFor()
    .onError(
        function(x) {
          true.isTrue();
          async();
          return x;
        }.lift()
    );
  }
  
  /**
  * Test parallel initial success with failure after a flatmap-
  */
  public function testPromisesFailure7() {
    var async   = Assert.createAsync( function() { } ,200);
    var outcome0 = 'ok0'.success();
    var outcome1 = 'ok1'.success();
    var outcome2 = new Promise().left('notok0');
    var outcome3 = new Promise().left('notok again');
    var outcome4 = new Promise();
    
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
        ).onError(
            function(x:Dynamic) {
              true.isTrue();
              async();
              return x;
              //['notok', 'notok again'].equals(cast x);
            }.lift()
        );
  }
  /**
  * Test error handler flow to callback.
  */
  public function testPromisesFailure8() {
    var async   = Assert.createAsync( function() { } ,200);
    var outcome0 = new stx.Promise(
        function (x) {
          return x;
        }.lift()
    );
    var outcome1 = 'ok1'.success();
    var outcome2 = new Promise();
    var outcome3 = new Promise().left('notok again');
    var outcome4 = new Promise();
    var outcome5 = new Promise().right('ok');
    
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
        .flatMap(
            function (x){
              return outcome2;
            }
        ).onError(
            function(x) {
              return x;
            }.lift()
        ).map(
            function(x) {
              return true;
            }
        ).foreach(
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
  public function testPromisesFailure6() {
    var async   = Assert.createAsync( function() { } ,200);
    var outcome1 = 'ok1'.success();
    var outcome2 = new Promise().left('notok');
    var outcome3 = new Promise().left('notok again');
    var outcome4 = new Promise();
    
    haxe.Timer.delay(
        function() {
          outcome4.right('ok1');
        }
        ,10
    );
    [outcome1, outcome2, outcome3,outcome4]
        .waitFor()
        .map( 
            function(arr) {
              return arr.foldl(
                '',
                    function(a, b) {
                      return a + b;
                    }
              );
            }
        ).onError(
            function(x:Dynamic) {
              true.isTrue();
              async();
              return x;
              //['notok', 'notok again'].equals(cast x);
            }.lift()
        );
  }
  /**
  * Test complex error handling conditions
  */
  public function testPromisesFailure9() {
    var async   = Assert.createAsync( function() { } , 200);
    var outcome1 = 'ok1'.success();
    var outcome2 = new Promise().left('notok');
    var outcome3 = new Promise().left('notok again');
    var outcome4 = new Promise();
    var errors   = 4;
    var count    = 0;

    haxe.Timer.delay(
        function() {
          outcome4.right('ok1');
        }
        ,10
    );
    
    [outcome1, outcome2, outcome3,outcome4]
        .waitFor()
        .onError(
            function(x:Dynamic) {
              count++;
              return x;
            }.lift()
        ).map( 
            function(arr) {
              return arr.foldl(
                '',
                    function(a, b) {
                      return a + b;
                    }
              );
            }
        ).onError(
            function(x:Dynamic) {
              count++;
              return x;
            }.lift()
        ).flatMap(
            function(succ) {
              return Promise.failure('');
            }
        ).onError(
            function(x:Dynamic) {
              count++;
              return x;
            }.lift()
        ).map(
            function(x) {
              return x;
            }
        ).onError(
            function(x:Dynamic) {
              count++;
              true.isTrue();
              Assert.equals( count , errors );
              async();
              return x;
            }.lift()
        );
  }
  /**
  * Test complex error handling conditions
  */
  public function testPromisesFailure10() {
    var async   = Assert.createAsync( function() { } , 200);
    var outcome1 = 'ok1'.success();
    var outcome4 = new Promise();
    var errors   = 2;
    var count    = 0;
    haxe.Timer.delay(
        function() {
          outcome4.right('ok1');
        }
        ,10
    );
    
    [outcome1, outcome4]
        .waitFor()
        .onError(
            function(x:Dynamic) {
              return x;
            }.lift()
        ).map( 
            function(arr) {
              return arr.foldl(
                '',
                    function(a, b) {
                      return a + b;
                    }
              );
            }
        ).onError(
            function(x:Dynamic) {
              return x;
            }.lift()
        ).flatMap(
            function(succ) {
              return Promise.failure('');
            }
        ).onError(
            function(x:Dynamic) {
              count++;
              return x;
            }.lift()
        ).map(
            function(x) {
              return x;
            }
        ).onError(
            function(x:Dynamic) {
              count++;
              Assert.equals( count , errors );
              true.isTrue();
              async();
              return x;
            }.lift()
        );
  }
}