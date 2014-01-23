package stx.rct;

import Stax.*;
import stx.Compare.*;
import stx.io.Log.*;
import stx.Chunk;
import stx.async.Eventual;

using stx.Tuples;
using stx.UnitTest;
using stx.Functions;

import stx.rct.*;

using stx.async.Arrowlet;
using stx.rx.Observable;
using stx.rx.Observer;

class DefaultReactorTest extends Suite{
  public function testDefaultReactor(u:TestCase):TestCase{
    var evt   = Eventual.unit();
    var a     = new DefaultReactor<Chunk<Int>>();
    var b     = a.observe();
    var d     = b.subscribe(
      function(x){
        evt.deliver(isEqual(Val(tuple2(9,1)),x));
      }.asObserver().mapi(tuple2.bind(9))
    );
        a.emit(Val(1));

    return u.add(evt.flatten());
  }
}

