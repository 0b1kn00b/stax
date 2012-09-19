package stx.plus;

using stx.Prelude;
import stx.Tuples;
import stx.Prelude;

import stx.test.TestCase;
import stx.test.Assert;

using stx.plus.Order;
using stx.plus.Equal;

using stx.Maths;

class OrderTest extends TestCase{
	public function testOrderForInt() {
    var order = Order.getOrderFor(1);
    assertTrue(order(2, 1)  > 0);
    assertTrue(order(1, 2)  < 0);
    assertTrue(order(1, 1) == 0);
  }

  public function testOrderForFloat() {
    var order = Order.getOrderFor(1.0);
    assertTrue(order(1.2, 1.1)  > 0);
    assertTrue(order(1.1, 1.2)  < 0);
    assertTrue(order(0.1, 0.1) == 0);
  }

  public function testOrderForBool() {
    var order = Order.getOrderFor(true);
    assertTrue(order(true,  false)  > 0);
    assertTrue(order(false, true)   < 0);
    assertTrue(order(true,  true)  == 0);
    assertTrue(order(false, false) == 0);
  }

  public function testOrderForNull() {   
    var order = Order.getOrderFor(null);
    assertTrue(order("s", null)   > 0);
    assertTrue(order(null, "s")   < 0);
    assertTrue(order(null, null) == 0);
  }  

  public function testOrderForString() {
    var order = Order.getOrderFor("s");
    assertTrue(order("b", "a")  > 0);
    assertTrue(order("a", "b")  < 0);
    assertTrue(order("a", null) > 0);
    assertTrue(order(null, "a") < 0);
    assertTrue(order("a", "a") == 0);
  }             

  public function testOrderForDate() {
    var a = Date.fromString("1999-12-31");
    var b = Date.fromString("2000-01-01");  
    var c = Date.fromString("1999-12-31");
    var order = Order.getOrderFor(b);
    assertTrue(order(b, a)    > 0);
    assertTrue(order(a, b)    < 0); 
    assertTrue(order(a, null) > 0);
    assertTrue(order(null, a) < 0);
    assertTrue(order(a, c)   == 0);
  }   

  public function testOrderForArray() {
    var a1 = [1,2,3];
    var a2 = [4];
    var a3 = [2,2,3];
    var a4 = [4]; 
    var order = Order.getOrderFor(a1);
    assertTrue(order(a1, a2)  > 0);
    assertTrue(order(a3, a1)  > 0); 
    assertTrue(order(a2, a1)  < 0);
    assertTrue(order(a1, a3)  < 0);  
    assertTrue(order(a2, a4) == 0); 
    assertTrue(order([], []) == 0);
  }

  public function testOrderForComparableClass() {   
    var c1 = new Comparable(1);
    var c2 = new Comparable(2);  
    var c3 = new Comparable(1);
    var order = Order.getOrderFor(c1);
    assertTrue(order(c2, c1)  > 0);
    assertTrue(order(c1, c2)  < 0);
    assertTrue(order(c1, c3) == 0);
  } 

  public function testOrderForNotComparableClass() {                 
    this.assertThrowsException(function() Order.getOrderFor(new Hash()));
  }

  public function testReflectiveOrderForDynamicComparableClass() {
    var c1 = new DynamicComparable(1);
    var c2 = new DynamicComparable(2);
    var c3 = new DynamicComparable(1);
    var order = Order.getOrderFor(c1);
    assertTrue(order(c2, c1)  > 0);
    assertTrue(order(c1, c2)  < 0);
    assertTrue(order(c1, c3) == 0);
  }

  public function testReflectiveOrderForDynamicComparableDescendingClass() {
    var c1 = new DynamicComparableDescending(1);
    var c2 = new DynamicComparableDescending(2);
    var c3 = new DynamicComparableDescending(1);
    var order = Order.getOrderFor(c1);
    assertTrue(order(c2, c1)  < 0);    
    assertTrue(order(c1, c2)  > 0);
    assertTrue(order(c1, c3) == 0);
  }

  public function testOrderForFunction() {                 
    this.assertThrowsException(function() Order.getOrderFor(function() trace("hello world")));
  }  

  public function testTupleOrder() {    
    var tests : Array<Tuple2<Product,Product>>= cast( 
      [
       Tuples.t2(Tuples.t2("b",0), Tuples.t2("a",0)),
       Tuples.t2(Tuples.t2("a",1), Tuples.t2("a",0)), 
       Tuples.t2(Tuples.t3("a",0,0.1), Tuples.t3("a",0,0.05)),
       Tuples.t2(Tuples.t4("a",0,0.1,"b"), Tuples.t4("a",0,0.1,"a")),
       Tuples.t2(Tuples.t5("a",0,0.1,"a",1), Tuples.t5("a",0,0.1,"a",0)), 
      ] 
    );
  
		tests.foreach(
				function(test:Tuple2 < Product, Product > ) {
					var l : Product = test._1;
					var r = test._2;
						assertTrue(Order.getOrderFor(l)(l, r) > 0, "failed to compare " + test._1 + " to " + test._2);
						assertTrue(l.compare(r) > 0, "failed to compare " + test._1 + " to " + test._2);  
				}
		);
  }
   public function testOrderForEnum() { 
    var o1 = None;
    var o2 = Some("a");
    var o3 = Some("b"); 
    var o4 = Some("a");
    var order = Order.getOrderFor(o1);
    assertTrue(order(o2, o1)  > 0);
    assertTrue(order(o3, o1)  > 0);
    assertTrue(order(o3, o2)  > 0);
    assertTrue(order(o1, o2)  < 0);
    assertTrue(order(o1, o3)  < 0);
    assertTrue(order(o2, o3)  < 0); 
    assertTrue(order(o1, o1) == 0);
    assertTrue(order(o2, o4) == 0);
  }    
  public function testTupleEqual() {    
    var tests : Array<Tuple2<Tuple2<Dynamic,Dynamic>,Tuple2<Dynamic,Dynamic>>> = cast ([
      Tuples.t2(Tuples.t2("b",0), Tuples.t2("b",0)),
      Tuples.t2(Tuples.t2("a",1), Tuples.t2("a",1)), 
      Tuples.t2(Tuples.t3("a",0,0.1), Tuples.t3("a",0,0.1)),
      Tuples.t2(Tuples.t4("a",0,0.1,"b"), Tuples.t4("a",0,0.1,"b")),
      Tuples.t2(Tuples.t5("a",0,0.1,"a",1), Tuples.t5("a",0,0.1,"a",1)), 
    ] );
    
    for(test in tests) {
      assertTrue(Equal.getEqualFor(test._1)(test._1, test._2));
      assertTrue(test._1.equals(test._2)); 

    } 
  }
  public function testGreaterThan() {
    assertTrue (Ints.compare.greaterThan()(2, 1));
    assertFalse(Ints.compare.greaterThan()(1, 1));

    assertTrue (Ints.compare.greaterThanOrEqual()(2, 1));
    assertTrue (Ints.compare.greaterThanOrEqual()(1, 1));
    assertFalse(Ints.compare.greaterThanOrEqual()(1, 2));

    assertTrue (Ints.compare.lessThan()(1, 2));
    assertFalse(Ints.compare.lessThan()(1, 1));

    assertTrue (Ints.compare.lessThanOrEqual()(1, 2));
    assertTrue (Ints.compare.lessThanOrEqual()(1, 1));
    assertFalse(Ints.compare.lessThanOrEqual()(2, 1));

    assertTrue (Ints.compare.notEqual()(2, 1));
    assertTrue (Ints.compare.notEqual()(1, 2));
    assertFalse(Ints.compare.notEqual()(1, 1));

    assertTrue (Ints.compare.equal()(1, 1));
    assertFalse(Ints.compare.equal()(1, 2));
  }
  /*
  public function testOrderForAnonymousTyped() {
    var o1 = { name : "haxe"};                      
    var o2 = { name : "stx"};
    var o3 = { name : "haxe"};
    var order = Order.getOrderFor(o1);
    assertTrue(order(o2, o1)      > 0);
    assertTrue(order(o1, o2)      < 0);
    assertTrue(order(o1, o3)     == 0); 
    assertTrue(order(o1, null)    > 0);
    assertTrue(order(null, o1)    < 0);
    assertTrue(order(null, null) == 0);
  }       */
}
private class Comparable
{                               
  var v : Int;
  public function new(v : Int) this.v = v
  public function compare(other : Comparable) return v == other.v ? 0 : (v > other.v ? 1 : -1)
}             

@DataClass private class DynamicComparable
{           
	var v : Int;  
	public function new(v : Int) this.v = v     
}
@DataClass private class DynamicComparableDescending
{  
  @DataField({order: -1})
	var v : Int;
	public function new(v : Int) this.v = v 
}