package stx.reactive;

import Stax.*;

import haxe.unit.TestCase;


import stx.async.Dissolvable;
import stx.async.dissolvable.*;

class DisposableTest extends TestCase{
  public function testRefCountDisposable(){
    var d : Dissolvable = noop;
    var a = new RefCountDissolvable(d);
    var b = a.lock();
    var c = a.lock();

    b.dissolve();
    a.dissolve();
    assertFalse(a.dissolved);
    c.dissolve();
    a.dissolve();
    assertTrue(a.dissolved);
  }
}