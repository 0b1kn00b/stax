package stx;
class FutureTest{
	public function testFutureChaining() {
    var f1: Future<Int> = Future.create();
    
    var f2 = f1.map(function(i) { return Std.string(i); }).flatMap(function(s): Future<Bool> { return Future.create().deliver(s.length < 2); });
    
    f1.deliver(9);
    
    assertEquals(true, f2.value().get());
  }
}