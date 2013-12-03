package rx;

import Stax.*;

import haxe.unit.TestCase;

import rx.disposable.*;

class DisposableTest extends TestCase{
  public function testRefCountDisposable(){
    var d : Disposable = noop;
    var a = new RefCountDisposable(d);
    var b = a.lock();
    var c = a.lock();

    b.dispose();
    a.dispose();
    assertFalse(a.disposed);
    c.dispose();
    a.dispose();
    assertTrue(a.disposed);
  }
}