package stx;

using stx.Prelude;
using stx.plus.Show;

import stx.test.TestCase;
using stx.Arrays;
using stx.ds.Set;
using stx.ds.List;
using stx.ds.Map;
using stx.ds.Group;
 
using stx.Tuples;


class ArraysTest extends TestCase {
  public function testPartition() {
    var t = [1,2,3,4,5,6].partition(function(v) return v % 2 != 0);  
    assertEquals(Tuples.t2([1,3,5], [2,4,6]), t);
  }
  
  public function testPartitionWhile() {
    var t = [1,2,3,4,5,6].partitionWhile(function(v) return v < 4);
    assertEquals(Tuples.t2([1,2,3], [4,5,6]), t);
  } 
  
  public function testMapTo() { 
    var r = [2, 3].mapTo(["1"], function(v : Int) return "" + v);
    assertEquals(["1","2","3"], r);
  }
  
  public function testFlatMapTo() {
    var r = ["2","3,4,5","6,7"].flatMapTo([1], function(v) {
      return v.split(",").map(function(i) return Std.parseInt(i));
    });
    assertEquals([1,2,3,4,5,6,7], r);                 
  }
  
  public function testCount() {
    assertEquals(3, [1,2,3,4,5].count(function(v) return v % 2 != 0));
  }
  
  public function testCountWhile() {
    assertEquals(2, [1,2,3,4,5].count(function(v) return v < 3));
  }
  
  public function testScanl() {
    var r = [1,2,3,4,5].scanl(1, function(a, b) return a + b);
    assertEquals([1,2,3,4,5,6], r);
  }
  
  public function testScanr() {
    var r = [1,2,3,4,5].scanr(1, function(a, b) return a + b);
    assertEquals([1,6,5,4,3,2], r);
  }
  
  public function testScanl1() {
    var r = [1,2,3,4,5].scanl1(function(a, b) return a + b);
    assertEquals([1,3,4,5,6], r);
  }
  
  public function testScanr1() {
    var r = [1,2,3,4,5].scanr1(function(a, b) return a + b);
    assertEquals([5,9,8,7,6], r);
  }
  
  public function testAppendAll() {
    assertEquals([1,2,3], [1].append([2,3]));
  }
  
  public function testIsEmpty() {
    assertTrue([].isEmpty());
    assertFalse([1].isEmpty());
  }
  
  public function testFind() {
    assertEquals(None, [1,2,3].find(function(v) return v == 4));
    assertEquals(Some(2), [1,2,3].find(function(v) return v == 2));
  }
  
  public function testForAll() {
    assertTrue([1,2,3].forAll(function(v) return v < 4));
    assertFalse([1,2,3].forAll(function(v) return v < 2));
  }
  
  public function testForAny() {
    assertFalse([1,2,3].forAny(function(v) return v > 3));
    assertTrue([1,2,3].forAny(function(v) return v < 2));
  } 
  
  public function testExists() {
    assertFalse([1,2,3].exists(function(v) return v == 4));
    assertTrue([1,2,3].exists(function(v) return v == 2));
  }
  
  public function testExistsP() {
    var f = function(v, ref) return v == ref;
    assertFalse([1,2,3].existsP(4, f));
    assertTrue([1,2,3].existsP(2, f));
  }
  
  public function testNubBy() {
    assertEquals([1,2,3], [1,2,2,3,1].nub());
  }                        
  
  public function testNub() {
    assertEquals([1,2,3], [1,2,2,3,1].nubBy(function(a,b) return a == b));
  }
  
  public function testIntersectBy() {
    assertEquals([2,3], [1,2,3].intersectBy([2,3,4,5], function(a,b) return a == b));
  }
  
  public function testIntersect() {
    assertEquals([2,3], [1,2,3].intersect([2,3,4,5]));  
  }
  
  public function testMkString() {
    assertEquals("A-B-C", ArrayShow.mkString(["a","b","c"],"-", function(s) return s.toUpperCase()));
  }
  
  public function testToMap() {
    var map = [Tuples.t2("a", 1), Tuples.t2("b", 2)].toMap();
    assertIs(map, stx.ds.Map);
    assertEquals(2, map.size());
  }
  
  public function testToList() {
    var list = [1,2,3].toList();
    assertIs(list, stx.ds.List);
    assertEquals(3, list.size());
  }
  
  public function testToSet() {
    var set = [1,2,2,3,1].toSet();
    assertIs(set, stx.ds.Set);
    assertEquals(3, set.size());
  }
  
  public function testGroupBy() {
    var arr = [1,2,3,4,5,6,7,8,9,10];
    var primes = [7, 5, 3, 2];
    var r = arr.groupBy(function(v) {
      for(p in primes)
        if(v % p == 0)
          return p;
      return 1;
    });
    assertEquals(
      Map.create()
      .set(1, [1])
      .set(2, [2,4,8])
      .set(3, [3,6,9])
      .set(5, [5, 10])
      .set(7, [7])
      ,
      r
    );
  }
}