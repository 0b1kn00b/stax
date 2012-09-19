package stx.functional;
import stx.ds.List; 
using stx.ds.List; 

import stx.ds.Map;

import stx.ds.Set;
using stx.ds.Set;

using stx.ds.Group;

import stx.Prelude;
import stx.test.TestCase;
import stx.functional.Foldables;

import stx.Tuples;

using stx.Maths;

using stx.functional.Foldables;

class FoldablesTest extends TestCase {
  public function testIntSetMapToString() {
    var seta = Set.create().addAll([1,2,3]);
    var setb = seta.map(function(i) return i.toString());
    assertEquals(["1", "2", "3"], setb.toArray()); 
  }
  
  public function testMapToList() {
    var list = Map.create().set("a", "A").set("b", "B").toList();
    assertIs(list, List);
    assertEquals(2, list.size());
  }
  
  public function testListToSet() {
    var set = List.create().addAll([1, 2, 2, 3]).toSet();
    assertIs(set, Set);
    assertEquals(3, set.size());
  }
  
  public function testSetToList() {
    var list = Set.create().addAll([1, 2, 3]).toList();
    assertIs(list, List);
    assertEquals(3, list.size());
  }
  
  public function testPartition() {
    var t = [1,2,3,4,5,6].toSet().partition(function(v) return v % 2 != 0);  
    assertEquals(Tuples.t2([1,3,5].toSet(), [2,4,6].toSet()), t);
  }
  
  public function testPartitionWhile() {
    var t = [1,2,3,4,5,6].toSet().partitionWhile(function(v) return v < 4);
    assertEquals(Tuples.t2([1,2,3].toSet(), [4,5,6].toSet()), t);
  }
  
  public function testScanl() {
    var r = [1,2,3,4,5].toSet().scanl(1, function(a, b) return a + b);
    assertEquals([1,2,3,4,5,6].toSet(), r);
  }         
  
  public function testScanr() {
    var r = [1,2,3,4,5].toSet().scanr(1, function(a, b) return a + b);
    assertEquals([1,6,5,4,3,2].toSet(), r);
  }
  
  public function testScanl1() {
    var r = [1,2,3,4,5].toSet().scanl1(function(a, b) return a + b);
    assertEquals([1,3,4,5,6].toSet(), r);
  }
  
  public function testScanr1() {
    var r = [1,2,3,4,5].toSet().scanr1(function(a, b) return a + b);
    assertEquals([5,9,8,7,6].toSet(), r);
  }
  
  public function testForAny() {
    assertFalse([1,2,3].toSet().forAny(function(v) return v > 3));
    assertTrue([1,2,3].toSet().forAny(function(v) return v < 2));
  } 
  
  public function testNubBy() {
    assertEquals([1,2,3].toList(), [1,2,2,3,1].toList().nub());
  }                        
  
  public function testNub() {
    assertEquals([1,2,3].toList(), [1,2,2,3,1].toList().nubBy(function(a,b) return a == b));
  }
  
  public function testIntersectBy() {
    assertEquals([2,3].toList(), [1,2,3].toList().intersectBy([2,3,4,5].toList(), function(a,b) return a == b));
  }
  
  public function testIntersect() {
    assertEquals([2,3].toList(), [1,2,3].toList().intersect([2,3,4,5].toList()));  
  } 
   
  public function testListGroupBy() {
    var list = List.create().appendAll([1,2,3,4,5,6,7,8,9,10]);
    var primes = [7, 5, 3, 2];
    var r = list.groupBy(function(v) {
      for(p in primes)
        if(v % p == 0)
          return p;
      return 1;
    });
    assertEquals(
      Map.create()
      .set(1, [1].toList())
      .set(2, [2,4,8].toList())
      .set(3, [3,6,9].toList())
      .set(5, [5, 10].toList())
      .set(7, [7].toList())
      ,
      cast r
    );
  } 
  
  public function testSetGroupBy() {
    var set = Set.create().appendAll([1,2,3,4,5,6,7,8,9,10]);
    var primes = [7, 5, 3, 2];
    var r :Map<Int,Iterable<Null<Int>>>=  set.groupBy(function(v) {
      for(p in primes)
        if(v % p == 0)
          return p;
      return 1;
    });
		var m : Map < Int, Iterable<Null<Int>> > = 
		Map.create()
      .set(1, [1].toSet().elements() )
      .set(2, [2,4,8].toSet().elements() )
      .set(3, [3,6,9].toSet().elements() )
      .set(5, [5, 10].toSet().elements())
      .set(7, [7].toSet().elements() );
    assertEquals(
      m
      ,
      r
    );
  }
} 

typedef Foo = {
  var barProp1:Int;
  var barProp2:Array<String>;
}