/*
 HaXe library written by John A. De Goes <john@socialmedia.com>
 Contributed by Social Media Networks

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the
 distribution.

 THIS SOFTWARE IS PROVIDED BY SOCIAL MEDIA NETWORKS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL SOCIAL MEDIA NETWORKS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
																	using SCore;
import stx.Prelude;
using stx.Tuples;
using stx.Future;

using stx.ds.plus.Equal;
using stx.ds.plus.Order;
using stx.ds.plus.Show;

import stx.ds.plus.Hasher;

import stx.test.TestCase;

using stx.Options;
using stx.Functions;

class PreludeTest extends TestCase {
  public function new() {
    super();
  }
  public function testCompose() {
    var f1 = function(i) { return i * 2; }
    var f2 = function(i) { return i - 1; }
    
    assertEquals(2, f1.compose(f2)(2));
  }
  public function testCurry2() {
    var f = function(i1, i2, i3) { return i1 + i2 + i3; }
    
    assertEquals(3, f.curry()(2)(-2)(3));
  }
  public function testFutureChaining() {
    var f1: Future<Int> = Future.create();
    
    var f2 = f1.map(function(i) { return Std.string(i); }).flatMap(function(s): Future<Bool> { return Future.create().deliver(s.length < 2); });
    
    f1.deliver(9);
    
    assertEquals(true, f2.value().get());
  }           

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

  public function testTupleString() {    
    var tests = [
      Tuples.t2(Tuples.t2("b",0), "stx.Tuple2(b, 0)"),
      Tuples.t2(Tuples.t2("a",1), "stx.Tuple2(a, 1)"), 
      Tuples.t2(Tuples.t3("a",0,0.1), "stx.Tuple3(a, 0, 0.1)"),
      Tuples.t2(Tuples.t4("a",0,0.1,"b"), "stx.Tuple4(a, 0, 0.1, b)"),
      Tuples.t2(Tuples.t5("a",0,0.1,"a",1), "stx.Tuple5(a, 0, 0.1, a, 1)"), 
    ];
    
    for (test in tests) {
			var l : Tuple2<String,Int> 	= test.element(0);
			var r : String 							=	test.element(1);
			
      assertEquals(r, Show.getShowFor(l)(l));
      //assertEquals(r, l.toString());       
    }
  }    
  @:todo('#0b1kn00b: the typer is now ignoring casts')
  public function testTupleHashCode() {    
    var tests : Array<HashFunction<Product>> = cast [
      cast Hasher.getHashFor(Tuples.t2("b",0)),
      cast Hasher.getHashFor(Tuples.t2("a",1)), 
      cast Hasher.getHashFor(Tuples.t3("a",0,0.1)),
      cast Hasher.getHashFor(Tuples.t4("a",0,0.1,"b")),
      cast Hasher.getHashFor(Tuples.t5("a",0,0.1,"a",1)), 
    ];
   
    while(tests.length > 0)
    {
      var value = tests.pop();
      // check is unique        
        assertFalse(tests.remove(value), "value is not unique hash: " + value);
      
      // check is different from zero
      assertNotEquals(0, value);
    } 
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
                     
  static function getShow<T>(v : T) return Show.getShowFor(v)(v)                           
  
  public function testShowFor() {         
    assertEquals("null",  getShow(null));
    assertEquals("true",  getShow(true));
    assertEquals("false", getShow(false));
    assertEquals("a",     getShow("a")); 
    assertEquals("1",  getShow(1));
    assertEquals("0.123",  getShow(0.123)); 
    assertEquals("{name:stx}",  getShow({ name : "stx" })); 
    assertEquals("[[1, 2], [3, 4]]", getShow([[1,2],[3,4]]));
    assertEquals("PreludeTest", getShow(this));
    assertEquals("_PreludeTest.HasEquals", getShow(new HasEquals(1)));
    assertEquals("<function>", getShow(function() trace("")));
    assertEquals("None", getShow(None));
    assertEquals("Some(Some(value))", getShow(Some(Some("value"))));
    assertEquals("_PreludeTest.HasNoHashAndShow()", getShow(new HasNoHashAndShow(1)));
    assertEquals("_PreludeTest.DynamicComparable(1)", getShow(new DynamicComparable(1)));
  }

  public function testHash() {
    assertHashCodeForIsZero(null);
    assertHashCodeForIsZero(0);
       
    assertHashCodeForIsNotZero(true);
    assertHashCodeForIsNotZero(false);
    assertHashCodeForIsNotZero("");
    assertHashCodeForIsNotZero("a");
    assertHashCodeForIsNotZero(1);
    assertHashCodeForIsNotZero(0.1);
    assertHashCodeForIsNotZero([]);
    assertHashCodeForIsNotZero([1]);
    assertHashCodeForIsNotZero({});
    assertHashCodeForIsNotZero({n:"a"});
    assertHashCodeForIsNotZero(new HasHash(1));
    assertHashCodeForIsNotZero(Date.fromString("2000-01-01"));       
    assertHashCodeForIsNotZero(None);
    assertHashCodeForIsNotZero(Some("a"));
  }

  public function testReflectiveHasher(){
    var zerocodes : Array<Dynamic> = [null, 0];
    for(z in zerocodes)
      assertEquals(0, Hasher.getHashFor(z)(z));

    var nonzerocodes : Array<Dynamic> = [true, false, "", "a", 1, 0.1, [],[1], {}, {n:"a"}, new HasNoHashAndShow(1), new HasHash(1), Date.fromString("2000-01-01"), None, Some("a")];
    for(n in nonzerocodes)
      this.assertNotEquals(0, Hasher.getHashFor(n)(n));
  }

  public function assertHashCodeForIsZero<T>(v : T) {
    assertEquals(0, Hasher.getHashFor(v)(v));
  }

  public function assertHashCodeForIsNotZero<T>(v : T) {
    assertNotEquals(0, Hasher.getHashFor(v)(v));
  }

  public function toString() return "PreludeTest"
}
   
private class HasEquals
{                               
  var v : Int;
  public function new(v : Int) this.v = v
  public function equals(other : HasEquals) return v == other.v
}

private class Comparable
{                               
  var v : Int;
  public function new(v : Int) this.v = v
  public function compare(other : Comparable) return v == other.v ? 0 : (v > other.v ? 1 : -1)
}             

private class HasHash
{
  var v : Int;
  public function new(v : Int) this.v = v
  public function hashCode() return v
}

@DataClass private class HasNoHashAndShow
{ 
  @DataField({show:false})   
	var v : Int;
	public function new(v : Int) this.v = v
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