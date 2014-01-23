package stx.reactive;

import stx.reactive.Rx.*;

using haxe.unit.TestCases;

import stx.io.Log.*;

import hx.Reactor;
import hx.reactive.Dispatcher;

import haxe.unit.TestCase;

using stx.Arrays;

class RxTest extends TestCase{
  public function testBuild(){
    var out                         = [];
    var reactor : Dispatcher<Int>   = new Dispatcher();
    var fn                          = out.push;
    var handler                     = reactive(reactor);
    var arr                         = [1,2];
    handler(fn);
    Arrays.each(arr,
      function(x){
        reactor.emit(x);
      }
    );

    handler(fn);

    this.isEqual(arr.append(arr),out);
  }
}