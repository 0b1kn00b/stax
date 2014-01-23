package stx;

import Stax.*;
using Prelude;

import stx.UnitTest;

using stx.Bools;
using stx.Strings;
using stx.async.Contract;
using stx.async.Eventual;
using stx.Maths;
using stx.Iterables;

class ContractTest extends Suite{
  public function new(){
    super();
  }
  /**
  * Resolve Right of Contract (success)
  */
  public function testRight(u:TestCase):TestCase {
    var a = new Contract();
    var b = a.map( 
        function(x:String) {
          return isEqual('ok',x);
        }
    );
    a.ok('ok');
    return u.add(b.ensure());
  }
  /**
  * Map success to value.
  */
  public function testMap(u:TestCase):TestCase {
    var a = 'ok'.intact();
    var b = a.map(
            function(x:String) {
              return 3;
            }
        ).map(
            function(y:Int) {
              return isEqual(3,y);
            }
        ).ensure();

    return u.add(b);
  }
  /*
  * Flatmap chain
  */
  public function testFlatMap(u:TestCase):TestCase{
    var o0 = new Eventual();
    var o1 = new Eventual();
    var a = 'ok'.intact();
        a.flatMap(
            function(x) {
              o0.deliver(isEqual('ok',x));
              return 'yup'.intact();
            }
        ).onSuccess(
            function(x) {
              o1.deliver(isEqual('yup',x));
            }
        );
    return u.add(o0).add(o1);
  }
  /**
  * Test Parallel execution
  */
  public function testContracts(u:TestCase):TestCase{
    return u.add(0.until(10)
        .map(
            function(int:Int) {
              return int.intact();
            }
        ).toArray().wait()
         .map(
            function(arr) {
              return arr.foldLeft(               
                0,
                function(int1:Int, int2:Int) {
                  return int1 + int2;
                }
              );
            }
         ).map(
            function(total) {
              return isEqual(45,total);
            }
        ).ensure());
  }
  /**
  * Test simple error handler
  */
  public function testContractFailure(u:TestCase):TestCase {
    var outcome2 = (fail(NativeError('notok')):Contract<Dynamic>)
        .map(
            function(x) {
              return isTrue(false);
              //['notok', 'notok again'].equals(cast x);
            }
        ).orUse(isTrue(true))
        .ensure();
    return u.add(outcome2);
  }
  /**
  * Test asynchronous failure
  */
  public function testContractsFailure0(u:TestCase):TestCase {
    var outcome2 = new Contract();
    var oc2      = new Eventual();

    hx.Timer.wait(
      function() {
        outcome2.no(fail(NativeError('notok')));
      },1
    );
    outcome2
        .onFailure(
          function(x:Dynamic) {
            oc2.deliver(isTrue(true));
            return x;
          }
        );
    return u.add(oc2);
  }
  /**
  * Test error flow through map
  */
  public function testContractsFailure2(u:TestCase):TestCase {
    var outcome = new Contract();
    var oc2     = new Eventual();

    hx.Timer.wait(
        function() {
          outcome.no(fail(NativeError(null)));
        }
        ,1
    );
    
    outcome
      .map(
          function(x) {
            return x;
          }
      ).onFailure(
          function(x:Dynamic) {
            oc2.deliver(isTrue(true));
          }
      );
    return u.add(oc2);
  }
  /**
  * Test error flow through flatmap
  */
  public function testContractsFailure3(u:TestCase):TestCase {
    var outcome = new Contract();
    var oc2     = new Eventual();

    hx.Timer.wait(
        function() {
          outcome.ok('ok1');
        }
        ,1
    );
    
    outcome
        .flatMap(
          function (x) {
            return new Contract().deliver(Failure(fail(NativeError('false'))));
          }
        ).onFailure(
            function(x:Dynamic) {
              oc2.deliver(isTrue(true));
            }
        );
    return u.add(oc2);
  } 
  /**
  * Test error flow through flatmap and map failing on flatmap
  */
  public function testContractsFailure4(u:TestCase):TestCase {
    var outcome = 'ok1'.intact();
    var oc2     = new Eventual();
    outcome
      .flatMap(
        function (x) {
          return new Contract().deliver(Failure(fail(NativeError('false'))));
        }
      ).map(
        function(x) {
          return x;
        }
      ).onFailure(
        function(x:Dynamic) {
          oc2.deliver(isTrue(true));
          return x;
        }
      );
    return u.add(oc2);
  }
  /**
  * Test error from parallel execution
  */
  public function testWaitFailer10(u:TestCase):TestCase {
    var outcome1  = 'ok1'.intact();
    var outcome2  = new Contract().deliver(Failure(fail(NativeError('notok'))));
    var oc3       = new Eventual();

    [outcome1, outcome2].wait()
    .map(
        function (x) {
          return x;
        }
    ).onFailure(
        function(x) {
          oc3.deliver(isTrue(true));
        }
    ).onSuccess(
        function(x) {
          oc3.deliver(isTrue(false));
        }
    );
    return u.add(oc3);
  }
  /**
  * Test mixed success / failure result in parallel
  */
    public function testWaitFailer11(u:TestCase):TestCase {
      var outcome1 = new Contract().deliver(Failure(fail(NativeError('ok1'))));
      var outcome2 = new Contract();
      var evt      = new Eventual();
      hx.Timer.wait(
          function() {
            outcome2.deliver(Failure(fail(NativeError('notok'))));
          }
          ,1
      );
    
    [outcome2, outcome1].wait()
    .onFailure(
      function(x) {
        evt.deliver(isTrue(true));
      }
    );
    return u.add(evt);
  }
  
  /**
  * Test parallel initial success with failure after a flatmap-
  */
  public function testContractsFailure7(u:TestCase):TestCase {
    var outcome0 = 'ok0'.intact();
    var outcome1 = 'ok1'.intact();
    var outcome2 : Contract<String> = fail(NativeError('notok0'));
    var outcome3 : Contract<String> = fail(NativeError('notok again'));
    var outcome4 = new Contract();
    
    hx.Timer.wait(
        function() {
          outcome4.no(fail(NativeError('notok')));
        }
        ,1
    );
    
    var oc = [outcome0, outcome1]
        .wait()
        .flatMap(
            function (x){
              return outcome4;
            }
        ).map(
            function(x) {
              return isTrue(false);
            }
        ).orUse(isTrue(true))
        .ensure();

    return u.add(oc);
  }
  /**
  * Test error handler flow to callback.
  */
 /* public function testContractsFailure8(u:TestCase):TestCase {
    var outcome0  = new Contract();

    var outcome1  = 'ok1'.intact();
    var outcome2  = new Contract();
    var outcome3  = fail(NativeError('notok again')).no();
    var outcome4  = new Contract();
    var outcome5  = 'ok'.intact();
    
    hx.Timer.wait(
        function() {
          outcome4.no('notok'.toError());
        }
        ,1
    );
    hx.Timer.wait(
        function() {
          outcome2.no('notok 2'.toError());
        }
        ,20
    );
    
    var counter = 0;
    
    hx.Timer.wait(
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
        ).onSuccess(
            function(x) {
              Assert.fail();
            }
        ).callback(
            function(err, res) {
              if (err != null) {
                true.isTrue();
              }
            }
        );
  }*/
  /**
  * More mixed mode parallel tests
  */
/*  public function testContractsFailure6(u:TestCase):TestCase {
    var async   = Assert.createAsync( function() { } ,200);
    var outcome1 = 'ok1'.intact();
    var outcome2 = fail(NativeError('notok')).no();
    var outcome3 = fail(NativeError('notok again')).no();
    var outcome4 = new Contract();
    
    hx.Timer.wait(
        function() {
          outcome4.ok('ok1');
        }
        ,10
    );
    [outcome1, outcome2, outcome3,outcome4]
        .wait()
        .map( 
            function(arr) {
              return arr.foldLeft(
                '',
                    function(a, b) {
                      return a + b;
                    }
              );
            }
        ).failure(
            function(x:Dynamic) {
              true.isTrue();
              return x;
              //['notok', 'notok again'].equals(cast x);
            }
        );
  }*/
  /**
  * Test complex error handling conditions
  */
 /* public function testContractsFailure9(u:TestCase):TestCase {
    var outcome1 = 'ok1'.intact();
    var outcome2 = fail(NativeError('notok')).no();
    var outcome3 = fail(NativeError('notok again')).no();
    var outcome4 = new Contract();
    var errors   = 4;
    var count    = 0;

    hx.Timer.wait(
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
              return arr.foldLeft(
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
              return fail(NativeError(''.no()));
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
              return x;
            }
        );
  }*/
  /**
  * Test complex error handling conditions
  */
 /* public function testContractsFailure10(u:TestCase):TestCase {
    var outcome1 = 'ok1'.intact();
    var outcome4 = new Contract();
    var errors   = 2;
    var count    = 0;
    hx.Timer.wait(
        function() {
          outcome4.ok('ok1');
        }
        ,10
    );
    var ocs : Array<Contract<Dynamic>> = [outcome1, outcome4];
    ocs
        .wait()
        .onSuccess(
            function(x:Dynamic) {
              return x;
            }
        ).map( 
            function(arr:Array<Dynamic>) {
              return arr.foldLeft(
                '',
                    function(a, b) {
                      return a + b;
                    }
              );
            }
        ).onSuccess(
            function(x:Dynamic) {
              return x;
            }
        ).flatMap(
            function(succ) {
              returnfail(NativeError( ''.no()));
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
            }
        );
    return u;
  }*/
}