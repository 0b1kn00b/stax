#Testing
##How to use UnitTest

    using stx.UnitTest;
    
    public function Tester extends Suite{
      public function testSomething(u:TestCase):TestCase{
        return u.add(this.isTrue(true));
      }
    }

The interesting thing is that the only thing resolved in the above is `true`. The `add` function is a deferred `stx.Arrays.add`, and
the `isTrue` function produces a function to be run later on with `true`. This allows for complete parallelism on a function-by-function basis.

To use `stx.Eventual`

    public function testDeferred(u:TestCase):TestCase{
      var evt = Eventual.unit();
      someAsynchronousFunction(
        function(someResult){
          evt.deliver(isEqual('helloworld',someResult));
        }
      );
      return u.add(evt);
    }

To do you're own custom tests:

    import stx.UnitTest.*;
    import stx.Compare.*;

    public function test(u:TestCase):TestCase{
      var tst = it(
        'should be equal',
        eq(3), //produces a Predicate<Int>
        3
      );
      return u.add(tst);
    }

##Architecture

A test (Proof) is an Arrowlet from TestResult to TestResult, that is: 

    function(x:TestResult,cont:TestResult->Void):Void

The `TestRig`, to run a test, sends in an empty `TestResult`, and the various ops that you line up are called.

A unit test `TestCase` is an Arrowlet from an array of Proofs to an Array of Proofs. Likewise, the rig sends in an empty array.

In a test:

    function test(u:TestCase):TestCase{
      return u;
    }

You attach future behaviours for the arrow to run by:

    u = u.add(test_arrow)

The execution strategy is:
  1) Parse an `rtti` class instance looking for functions `TestCase->TestCase`. 
  2) Push a `TestCase` through which will pick up the various `Proofs` to be run.
  3) Apply `TestCase` with an empty array, which produces `Array<Proof>`
  4) Apply each `Proof` with a `TestResult`.

There are loads of strategies available for 4, stop on first error, collect errors, parallel or serial, coming from the notion that a list of
arrows is a basis for parallelism.
