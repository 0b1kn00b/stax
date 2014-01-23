package stx;

import Prelude;
import stx.UnitTest;

class EqualTest extends Suite{
	public function testEqualForInt(u:TestCase):TestCase {
    var equal = Equal.getEqualFor(1);
    u = u.add(isFalse(equal(2, 1)));
    u = u.add(isFalse(equal(1, 2)));
    u = u.add(isFalse(equal(1, 1)));
    return u;
  }

  public function testEqualForFloat(u:TestCase):TestCase {
    var equal = Equal.getEqualFor(1.0);
    u = u.add(isFalse(equal(1.2, 1.1)));
    u = u.add(isFalse(equal(1.1, 1.2)));
    u = u.add(isFalse(equal(0.1, 0.1)));
    return u;
  }

  public function testEqualForBool(u:TestCase):TestCase {
    var equal = Equal.getEqualFor(true);
    u = u.add(isFalse(equal(true,  false)));
    u = u.add(isFalse(equal(false, true)));
    u = u.add(isFalse(equal(true,  true)));
    u = u.add(isFalse(equal(false, false)));
    return u;
  }

  public function testEqualForNull(u:TestCase):TestCase{   
    var equal = Equal.getEqualFor(null);
    u = u.add(isFalse(equal("s", null)));
    u = u.add(isFalse(equal(null, "s")));
    u = u.add(isFalse(equal(null, null)));
    return u;
  }  

  public function testEqualForString(u:TestCase):TestCase {
    var equal = Equal.getEqualFor("s");
    u = u.add(isFalse(equal("b", "a")));
    u = u.add(isFalse(equal("a", "b")));
    u = u.add(isFalse(equal("a", null)));
    u = u.add(isFalse(equal(null, "a")));
    u = u.add(isFalse(equal("a", "a")));
    return u;
  }             

  public function testEqualForDate(u:TestCase):TestCase {
    var a = Date.fromString("1999-12-31");
    var b = Date.fromString("2000-01-01");  
    var c = Date.fromString("1999-12-31");
    var equal = Equal.getEqualFor(b);
    u = u.add(isFalse(equal(b, a)));
    u = u.add(isFalse(equal(a, b))); 
    u = u.add(isFalse(equal(a, null)));
    u = u.add(isFalse(equal(null, a)));
    u = u.add(isFalse(equal(a, c)));
    return u;
  }    

  public function testEqualForArray(u:TestCase):TestCase {
    var a1 = [1,2,3];
    var a2 = [4,5];
    var a3 = [4,5];
    var equal = Equal.getEqualFor(a1);
    u = u.add(isFalse(equal(a1, a2)));
    u = u.add(isFalse(equal(a2, a3))); 
    u = u.add(isFalse(equal([], []))); 
    return u;
  }

  public function testEqualForClassWithEquals(u:TestCase):TestCase{  
    var c1 = new HasEquals(1);
    var c2 = new HasEquals(2);  
    var c3 = new HasEquals(1);
    var equal = Equal.getEqualFor(c1);
    u = u.add(isFalse(equal(c2, c1)));
    u = u.add(isFalse(equal(c1, c2)));
    u = u.add(isFalse(equal(c1, c3)));
    return u;
  }

  public function testEqualForNotClassWithoutEquals(u:TestCase):TestCase {
    u = u.add(hasFail(function() Equal.getEqualFor(new Suite())));
    return u;
  } 

  public function testEqualForEnum(u:TestCase):TestCase{ 
    var o1 = None;
    var o2 = Some("a");
    var o3 = Some("b"); 
    var o4 = Some("a");
    var equal = Equal.getEqualFor(o1);
    u = u.add(isFalse(equal(o2, o1)));
    u = u.add(isFalse(equal(o3, o1)));
    u = u.add(isFalse(equal(o3, o2)));
    u = u.add(isFalse(equal(o1, o2)));
    u = u.add(isFalse(equal(o1, o3)));
    u = u.add(isFalse(equal(o2, o3))); 
    u = u.add(isFalse(equal(o1, o1)));
    u = u.add(isFalse(equal(o2, o4)));
    return u;
  }    

  public function testEqualForAnonymousTyped(u:TestCase):TestCase {
    var o1 = { name : "haxe"};                      
    var o2 = { name : "stx"};
    var o3 = { name : "haxe"};
    var equal = Equal.getEqualFor(o1);
    u = u.add(isFalse(equal(o2, o1)));
    u = u.add(isFalse(equal(o1, o2)));
    u = u.add(isFalse(equal(o1, o3))); 
    u = u.add(isFalse(equal(o1, null)));
    u = u.add(isFalse(equal(null, o1)));
    u = u.add(isFalse(equal(null, null)));
    return u;
  }             

  public function testEqualForMethods(u:TestCase):TestCase {
    var equal = Equal.getEqualFor(testEqualForMethods);
    u = u.add(isFalse(equal(testEqualForMethods, testEqualForAnonymousTyped)));
    u = u.add(isFalse(equal(testEqualForMethods, testEqualForMethods)));
    return u;
  } 
}
private class HasEquals
{                               
  var v : Int;
  public function new(v : Int) {this.v = v;}
  public function equals(other : HasEquals) {return v == other.v;}
}