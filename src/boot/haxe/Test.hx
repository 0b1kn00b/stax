import haxe.unit.*;

using stx.Arrays;

class Test{
  static function main(){
    new Test();
  }
  function new(){
    var runner = new TestRunner();
    var tests : Array<TestCase> = 
    [
      new hx.sch.SchedulerTest(),
      /*new stx.ReducerTest(),
      new rx.RxTest(),
      new rx.FutureTest(),
      new rx.ObserverTest(),
      new rx.ObservableTest(),
      new rx.DisposableTest(),*/
    ];
    tests.each(runner.add);
    runner.run();
  }
}
