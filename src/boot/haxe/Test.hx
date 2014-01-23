import haxe.unit.TestRunner;
import haxe.unit.TestCase;

#if (cpp || java)
  using stx.Arrays;

  class Test{
    static function main(){
      trace('entry point');
      new Test();
    }
    function new(){
      var runner = new TestRunner();
      var tests : Array<TestCase> = 
      [
        new stx.UnitTestTest(),
      ];
      tests.each(runner.add);
      runner.run();
    }
  }
#else
import hx.ifs.Scheduler;
import hx.scheduler.InlineScheduler;

import stx.ioc.Inject.*;

using stx.Arrays;

import stx.async.impl.Eventual;

class Test{
  static function main(){
    trace('entry point');
    new Test();
  }
  function new(){
    Stax.init();
    injector().unbind(Scheduler);
    #if sys
      injector().bind(Scheduler,new InlineScheduler());
    #end
    var runner = new TestRunner();
    var tests : Array<TestCase> = 
    [
      new SysTest(),
      new stx.UnitTestTest(),
      /*
      new stx.async.FutureTest(),
      
      new stx.reactive.SignalTest(),
      new stx.async.EventualTest(),
      #if neko
      new NekoTest(),
      #end
      new stx.reactive.ObservableTest(),
      
      new stx.async.ArrowletTest(),
      new stx.reactive.RxTest(),
      new stx.reactive.ObserverTest(),
      new stx.ds.RangeTest(),
      new hx.scheduler.SchedulerTest(),
      new stx.reactive.RxTest(),
      new stx.reactive.DisposableTest(),*/
    ];
    tests.each(runner.add);
    runner.run();
    inject(Scheduler).run();
  }
}
#end