package stx.plus;

import haxe.ds.HashMap;

import Prelude;
import stx.Tuples;

import stx.Muster;
import stx.Muster.*;
import stx.Log.*;
import stx.Compare.*;

using Prelude;
using stx.Tuples;
using stx.Maths;

using stx.plus.Order;
using stx.plus.Equal;

class OrderTest extends TestCase{
	public function testOrderForInt(u:UnitArrow):UnitArrow {
    var order = Order.getOrderFor(1);
    u = u.add(isTrue(order(2, 1)  > 0));
    u = u.add(isTrue(order(1, 2)  < 0));
    u = u.add(isTrue(order(1, 1) == 0));
    return u;
  }

  public function testOrderForFloat(u:UnitArrow):UnitArrow {
    var order = Order.getOrderFor(1.0);
    u = u.add(isTrue(order(1.2, 1.1)  > 0));
    u = u.add(isTrue(order(1.1, 1.2)  < 0));
    u = u.add(isTrue(order(0.1, 0.1) == 0));
    return u;
  }

  public function testOrderForBool(u:UnitArrow):UnitArrow {
    var order = Order.getOrderFor(true);
    u = u.add(isTrue(order(true,  false)  > 0));
    u = u.add(isTrue(order(false, true)   < 0));
    u = u.add(isTrue(order(true,  true)  == 0));
    u = u.add(isTrue(order(false, false) == 0));
    return u;
  }

  public function testOrderForNull(u:UnitArrow):UnitArrow {   
    var order = Order.getOrderFor(null);
    u = u.add(isTrue(order("s", null)   > 0));
    u = u.add(isTrue(order(null, "s")   < 0));
    u = u.add(isTrue(order(null, null) == 0));
    return u;
  }  

  public function testOrderForString(u:UnitArrow):UnitArrow {
    var order = Order.getOrderFor("s");
    u = u.add(isTrue(order("b", "a")  > 0));
    u = u.add(isTrue(order("a", "b")  < 0));
    u = u.add(isTrue(order("a", null) > 0));
    u = u.add(isTrue(order(null, "a") < 0));
    u = u.add(isTrue(order("a", "a") == 0));
    return u;
  }             

  public function testOrderForDate(u:UnitArrow):UnitArrow {
    var a = Date.fromString("1999-12-31");
    var b = Date.fromString("2000-01-01");  
    var c = Date.fromString("1999-12-31");
    var order = Order.getOrderFor(b);
    u = u.add(isTrue(order(b, a)    > 0));
    u = u.add(isTrue(order(a, b)    < 0)); 
    u = u.add(isTrue(order(a, null) > 0));
    u = u.add(isTrue(order(null, a) < 0));
    u = u.add(isTrue(order(a, c)   == 0));
    return u;
  }   

  public function testOrderForArray(u:UnitArrow):UnitArrow {
    var a1 = [1,2,3];
    var a2 = [4];
    var a3 = [2,2,3];
    var a4 = [4]; 
    var order = Order.getOrderFor(a1);
    u = u.add(isTrue(order(a1, a2)  > 0));
    u = u.add(isTrue(order(a3, a1)  > 0)); 
    u = u.add(isTrue(order(a2, a1)  < 0));
    u = u.add(isTrue(order(a1, a3)  < 0)); 
    u = u.add(isTrue(order(a2, a4) == 0));
    u = u.add(isTrue(order([], []) == 0));
    return u;
  }

  /*public function testOrderForComparableClass(u:UnitArrow):UnitArrow {   
    var c1 = new Comparable(1);
    var c2 = new Comparable(2);  
    var c3 = new Comparable(1);
    var order = Order.getOrderFor(c1);
    u = u.add(isTrue(order(c2, c1)  > 0));
    u = u.add(isTrue(order(c1, c2)  < 0));
    u = u.add(isTrue(order(c1, c3) == 0));
    return u;
  } 

  public function testOrderForNotComparableClass(u:UnitArrow):UnitArrow {                 
    u = u.add(hasFail(function() Order.getOrderFor(new NotComparable())));
    return u;
  }*/

  public function testReflectiveOrderForDynamicComparableClass(u:UnitArrow):UnitArrow {
    var c1 = new DynamicComparable(1);
    var c2 = new DynamicComparable(2);
    var c3 = new DynamicComparable(1);
    var order = Order.getOrderFor(c1);
    u = u.add(isTrue(order(c2, c1)  > 0));
    u = u.add(isTrue(order(c1, c2)  < 0));
    u = u.add(isTrue(order(c1, c3) == 0));
    return u;
  }

  public function testReflectiveOrderForDynamicComparableDescendingClass(u:UnitArrow):UnitArrow {
    var c1 = new DynamicComparableDescending(1);
    var c2 = new DynamicComparableDescending(2);
    var c3 = new DynamicComparableDescending(1);
    var order = Order.getOrderFor(c1);
    u = u.add(isTrue(order(c2, c1)  < 0)); 
    u = u.add(isTrue(order(c1, c2)  > 0));
    u = u.add(isTrue(order(c1, c3) == 0));
    return u;
  }

  public function testOrderForFunction(u:UnitArrow):UnitArrow {                 
    u = u.add(hasFail(function() Order.getOrderFor(function() trace("hello world"))));
    return u;
  }
  /*public function testTupleOrder(u:UnitArrow):UnitArrow {    
    var tests : Array<Dynamic>= cast( 
      [
       tuple2(tuple2("b",0), tuple2("a",0)),
       tuple2(tuple2("a",1), tuple2("a",0)), 
       tuple2(tuple3("a",0,0.1), tuple3("a",0,0.05)),
       tuple2(tuple4("a",0,0.1,"b"), tuple4("a",0,0.1,"a")),
       tuple2(tuple5("a",0,0.1,"a",1), tuple5("a",0,0.1,"a",0)), 
      ] 
    );
  
		tests.each(
				function(test:Tuple2 < Product, Product > ) {
					var l : Product = test.fst();
					var r = test.snd();
						u = u.add(isTrue(Order.getOrderFor(l)(l, r) > 0, "failed to compare " + test.fst() + " to " + test.snd()));
						u = u.add(isTrue(l.compare(r) > 0, "failed to compare " + test.fst() + " to " + test.snd()); ) 
				}
		);
  }*/
   public function testOrderForEnum(u:UnitArrow):UnitArrow { 
    var o1 = None;
    var o2 = Some("a");
    var o3 = Some("b"); 
    var o4 = Some("a");
    var order = Order.getOrderFor(o1);
    u = u.add(isTrue(order(o2, o1)  > 0));
    u = u.add(isTrue(order(o3, o1)  > 0));
    u = u.add(isTrue(order(o3, o2)  > 0));
    u = u.add(isTrue(order(o1, o2)  < 0));
    u = u.add(isTrue(order(o1, o3)  < 0));
    u = u.add(isTrue(order(o2, o3)  < 0)); 
    u = u.add(isTrue(order(o1, o1) == 0));
    u = u.add(isTrue(order(o2, o4) == 0));
    return u;
  }    
/*  public function testTupleEqual(u:UnitArrow):UnitArrow {    
    var tests : Array<Dynamic> = cast ([
      tuple2(tuple2("b",0), tuple2("b",0)),
      tuple2(tuple2("a",1), tuple2("a",1)), 
      tuple2(tuple3("a",0,0.1), tuple3("a",0,0.1)),
      tuple2(tuple4("a",0,0.1,"b"), tuple4("a",0,0.1,"b")),
      tuple2(tuple5("a",0,0.1,"a",1), tuple5("a",0,0.1,"a",1)), 
    ] );
    
    for(test in tests) {
      u = u.add(isTrue(Equal.getEqualFor(test.fst())(test.fst(), test.snd())));
      u = u.add(isTrue(test.fst().equals(test.snd()));) 

    } 
  }*/
  public function testGreaterThan(u:UnitArrow):UnitArrow {
    u = u.add(isTrue (Ints.compare.greaterThan()(2, 1)));
    u = u.add(isFalse(Ints.compare.greaterThan()(1, 1)));

    u = u.add(isTrue (Ints.compare.greaterThanOrEqual()(2, 1)));
    u = u.add(isTrue (Ints.compare.greaterThanOrEqual()(1, 1)));
    u = u.add(isFalse(Ints.compare.greaterThanOrEqual()(1, 2)));

    u = u.add(isTrue (Ints.compare.lessThan()(1, 2)));
    u = u.add(isFalse(Ints.compare.lessThan()(1, 1)));

    u = u.add(isTrue (Ints.compare.lessThanOrEqual()(1, 2)));
    u = u.add(isTrue (Ints.compare.lessThanOrEqual()(1, 1)));
    u = u.add(isFalse(Ints.compare.lessThanOrEqual()(2, 1)));

    u = u.add(isTrue (Ints.compare.notEqual()(2, 1)));
    u = u.add(isTrue (Ints.compare.notEqual()(1, 2)));
    u = u.add(isFalse(Ints.compare.notEqual()(1, 1)));

    u = u.add(isTrue (Ints.compare.equal()(1, 1)));
    u = u.add(isFalse(Ints.compare.equal()(1, 2)));
    return u;
  }
  
  public function testOrderForAnonymousTyped(u:UnitArrow):UnitArrow {
    var o1 = { name : "haxe"};                      
    var o2 = { name : "stx"};
    var o3 = { name : "haxe"};
    var order = Order.getOrderFor(o1);
    u = u.add(isTrue(order(o2, o1)      > 0));
    u = u.add(isTrue(order(o1, o2)      < 0));
    u = u.add(isTrue(order(o1, o3)     == 0)); 
    u = u.add(isTrue(order(o1, null)    > 0));
    u = u.add(isTrue(order(null, o1)    < 0));
    u = u.add(isTrue(order(null, null) == 0));
    return u;
  }       
}
private class NotComparable{
  public function new(){}
}
private class Comparable
{                               
  var v : Int;
  public function new(v : Int) this.v = v;
  public function compare(other : Comparable) return v == other.v ? 0 : (v > other.v ? 1 : -1);
}             

@DataClass private class DynamicComparable
{           
	var v : Int;  
	public function new(v : Int) this.v = v;     
}
@DataClass private class DynamicComparableDescending
{  
  @DataField({order: -1})
	var v : Int;
	public function new(v : Int) this.v = v; 
}