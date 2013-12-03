package stx.plus;

import stx.test.Suite;
import stx.test.Assert;
class ShowTest extends Suite{
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
    assertEquals("_PreludeTest.HasNoMapAndShow()", getShow(new HasNoMapAndShow(1)));
    assertEquals("_PreludeTest.DynamicComparable(1)", getShow(new DynamicComparable(1)));
  }
  public function testTupleString() {    
    var tests = [
      tuple2(tuple2("b",0), "stx.Tuple2(b, 0)"),
      tuple2(tuple2("a",1), "stx.Tuple2(a, 1)"), 
      tuple2(Tuples.t3("a",0,0.1), "stx.Tuple3(a, 0, 0.1)"),
      tuple2(Tuples.t4("a",0,0.1,"b"), "stx.Tuple4(a, 0, 0.1, b)"),
      tuple2(Tuples.t5("a",0,0.1,"a",1), "stx.Tuple5(a, 0, 0.1, a, 1)"), 
    ];
    
    for (test in tests) {
			var l : Tuple2<String,Int> 	= test.element(0);
			var r : String 							=	test.element(1);
			
      assertEquals(r, Show.getShowFor(l)(l));
      //assertEquals(r, l.toString());       
    }
  }
}