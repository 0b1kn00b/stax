package stx.plus;
class EqualTest extends TestCase{
	public function testEqualForInt() {
    var equal = Equal.getEqualFor(1);
    assertFalse(equal(2, 1));
    assertFalse(equal(1, 2));
    assertTrue(equal(1, 1));
  }

  public function testEqualForFloat() {
    var equal = Equal.getEqualFor(1.0);
    assertFalse(equal(1.2, 1.1));
    assertFalse(equal(1.1, 1.2));
    assertTrue(equal(0.1, 0.1));
  }

  public function testEqualForBool() {
    var equal = Equal.getEqualFor(true);
    assertFalse(equal(true,  false));
    assertFalse(equal(false, true));
    assertTrue(equal(true,  true));
    assertTrue(equal(false, false));
  }

  public function testEqualForNull() {   
    var equal = Equal.getEqualFor(null);
    assertFalse(equal("s", null));
    assertFalse(equal(null, "s"));
    assertTrue(equal(null, null));
  }  

  public function testEqualForString() {
    var equal = Equal.getEqualFor("s");
    assertFalse(equal("b", "a"));
    assertFalse(equal("a", "b"));
  assertFalse(equal("a", null));
    assertFalse(equal(null, "a"));
    assertTrue(equal("a", "a"));
  }             

  public function testEqualForDate() {
    var a = Date.fromString("1999-12-31");
    var b = Date.fromString("2000-01-01");  
    var c = Date.fromString("1999-12-31");
    var equal = Equal.getEqualFor(b);
    assertFalse(equal(b, a));
    assertFalse(equal(a, b)); 
    assertFalse(equal(a, null));
    assertFalse(equal(null, a));
    assertTrue(equal(a, c));
  }    

  public function testEqualForArray() {
    var a1 = [1,2,3];
    var a2 = [4,5];
    var a3 = [4,5];
    var equal = Equal.getEqualFor(a1);
    assertFalse(equal(a1, a2));
    assertTrue(equal(a2, a3)); 
    assertTrue(equal([], [])); 
  }

  public function testEqualForClassWithEquals() {   
    var c1 = new HasEquals(1);
    var c2 = new HasEquals(2);  
    var c3 = new HasEquals(1);
    var equal = Equal.getEqualFor(c1);
    assertFalse(equal(c2, c1));
    assertFalse(equal(c1, c2));
    assertTrue(equal(c1, c3));
  }

  public function testEqualForNotClassWithoutEquals() {                 
    this.assertThrowsException(function() Equal.getEqualFor(new TestCase()));
  } 

  public function testEqualForEnum() { 
    var o1 = None;
    var o2 = Some("a");
    var o3 = Some("b"); 
    var o4 = Some("a");
    var equal = Equal.getEqualFor(o1);
    assertFalse(equal(o2, o1));
    assertFalse(equal(o3, o1));
    assertFalse(equal(o3, o2));
    assertFalse(equal(o1, o2));
    assertFalse(equal(o1, o3));
    assertFalse(equal(o2, o3)); 
    assertTrue(equal(o1, o1));
    assertTrue(equal(o2, o4));
  }    

  public function testEqualForAnonymousTyped() {
    var o1 = { name : "haxe"};                      
    var o2 = { name : "stx"};
    var o3 = { name : "haxe"};
    var equal = Equal.getEqualFor(o1);
    assertFalse(equal(o2, o1));
    assertFalse(equal(o1, o2));
    assertTrue(equal(o1, o3)); 
    assertFalse(equal(o1, null));
    assertFalse(equal(null, o1));
    assertTrue(equal(null, null));
  }             

  public function testEqualForMethods() {
    var equal = Equal.getEqualFor(testEqualForMethods);
    assertFalse(equal(testEqualForMethods, testEqualForAnonymousTyped));
    assertTrue(equal(testEqualForMethods, testEqualForMethods));
  } 
}
private class HasEquals
{                               
  var v : Int;
  public function new(v : Int) this.v = v
  public function equals(other : HasEquals) return v == other.v
}