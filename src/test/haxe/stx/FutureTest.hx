package stx;
class EventualTest{
	public function testEventualChaining() {
    var f1: Eventual<Int> = Eventual.create();
    
    var f2 = f1.map(function(i) { return Std.string(i); }).flatMap(function(s): Eventual<Bool> { return Eventual.create().deliver(s.length < 2); });
    
    f1.deliver(9);
    
    assertEquals(true, f2.value().get());
  }
}