package stx;

import Prelude;

using stx.Tuples;
import stx.Show.*;
import stx.UnitTest;

class ShowTest extends Suite{
	public function testShowFor(u:TestCase):TestCase {         
    var tests = [
      isEqual("null",  getShow(null)),
      isEqual("true",  getShow(true)),
      isEqual("false", getShow(false)),
      isEqual("a",     getShow("a")), 
      isEqual("1",  getShow(1)),
      isEqual("0.123",  getShow(0.123)), 
      isEqual("{name:stx}",  getShow({ name : "stx" })), 
      isEqual("[[1, 2], [3, 4]]", getShow([[1,2],[3,4]])),
      isEqual("PreludeTest", getShow(this)),
      //isEqual("_PreludeTest.HasEquals", getShow(new HasEquals(1))),
      isEqual("<function>", getShow(function() trace(""))),
      isEqual("None", getShow(None)),
      isEqual("Some(Some(value))", getShow(Some(Some("value")))),
      //isEqual("_PreludeTest.HasNoMapAndShow()", getShow(new HasNoMapAndShow(1))),
      //isEqual("_PreludeTest.DynamicComparable(1)", getShow(new DynamicComparable(1))),
    ];
    return u.append(tests);
  }
  public function testTupleString(u:TestCase):TestCase {    
    var tests = [
      tuple2(tuple2("b",0), "stx.Tuple2(b, 0)"),
      tuple2(tuple2("a",1), "stx.Tuple2(a, 1)"), 
      tuple2(tuple3("a",0,0.1), "stx.Tuple3(a, 0, 0.1)"),
      tuple2(tuple4("a",0,0.1,"b"), "stx.Tuple4(a, 0, 0.1, b)"),
      tuple2(tuple5("a",0,0.1,"a",1), "stx.Tuple5(a, 0, 0.1, a, 1)"), 
    ];
    
    var tests0 = tests.map(
      function(test:Product){
        var l : Tuple2<String,Int>  = cast test.element(0);
        var r : String              = cast test.element(1);
        return isEqual(r, Show.getShowFor(l)(l));
      }
    );
    return u.append(tests0);
  }
}