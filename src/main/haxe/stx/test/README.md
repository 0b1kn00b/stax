#Testing
##How to use UnitTest

    using stx.UnitTest;
    
    public function Tester extends TestCase{
      public function testSomething(u:UnitArrow):UnitArrow{
        return u.add(this.isTrue(true));
      }
    }

The interesting thing is that the only thing resolved in the above is `true`. The `add` function is a deferred `stx.Arrays.add`, and
the `isTrue` function produces a function to be run later on with `true`. This allows for complete parallelism on a function-by-function basis.

To use `stx.Eventual`

    public function testDeferred(u:UnitArrow):UnitArrow{
      var evt = Eventual.unit();
      someAsynchronousFunction(
        function(someResult){
          evt.deliver(isEqual('helloworld',someResult));
        }
      );
      return u.add(evt.flatten());
    }

The flatten function turns the `Eventual<TestArrow>` into a `TestArrow`, there is also a version for `Eventual<Array<TestArrow>>`, and they both come with `using stx.UnitTest`.

To do you're own custom tests:

    import stx.UnitTest.*;
    import stx.Compare.*;

    public function test(u:UnitArrow):UnitArrow{
      var tst = it(
        'should be equal',
        eq(3), //produces a Predicate<Int>
        3
      );
      return u.add(tst);
    }

##Architecture

A test (TestArrow) is an Arrow from TestResult to TestResult, that is: 

    function(x:TestResult,cont:TestResult->Void):Void

The `TestRig`, to run a test, sends in an empty `TestResult`, and the various ops that you line up are called.

A unit test `UnitArrow` is an Arrow from an array of TestArrows to an Array of TestArrows. Likewise, the rig sends in an empty array.

In a test:

    function test(u:UnitArrow):UnitArrow{
      return u;
    }

You attach future behaviours for the arrow to run by:

    u = u.add(test_arrow)

The execution strategy is:
  1) Parse an `rtti` class instance looking for functions `UnitArrow->UnitArrow`. 
  2) Push a `UnitArrow` through which will pick up the various `TestArrows` to be run.
  3) Apply `UnitArrow` with an empty array, which produces `Array<TestArrow>`
  4) Apply each `TestArrow` with a `TestResult`.

There are loads of strategies available for 4, stop on first error, collect errors, parallel or serial, coming from the notion that a list of
arrows is a basis for parallelism.
