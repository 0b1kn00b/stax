package stx;

import stx.Muster;
import stx.Muster.*;
import stx.Compare.*;

using stx.Tuples;

using Prelude;
using stx.plus.Show;

using stx.Arrays;
using stx.ds.Set;
using stx.ds.List;
using stx.ds.Map;
using stx.ds.Group;
 
using stx.Tuples;


class ArraysTest extends TestCase {
  public function testPartition(u:UnitArrow):UnitArrow {
    var t = [1,2,3,4,5,6].partition(function(v) return v % 2 != 0);  
    u = u.add(it('should be equal',eq(tuple2([1,3,5], [2,4,6])), t));
    return u;
  }
  
  public function testPartitionWhile(u:UnitArrow):UnitArrow {
    var t = [1,2,3,4,5,6].partitionWhile(function(v) return v < 4);
    u = u.add(it('should be equal',eq(tuple2([1,2,3], [4,5,6])), t));
    return u;
  } 
  
  public function testMapTo(u:UnitArrow):UnitArrow { 
    var r = [2, 3].mapTo(["1"], function(v : Int) return "" + v);
    u = u.add(it('should be equal',eq(["1","2","3"]), r));
    return u;
  }
  
  public function testFlatMapTo(u:UnitArrow):UnitArrow {
    var r = ["2","3,4,5","6,7"].flatMapTo([1], function(v) {
      return v.split(",").map(function(i) return Std.parseInt(i));
    });
    u = u.add(it('should be equal',eq([1,2,3,4,5,6,7]), r)); 
    return u;
  }
  
  public function testCount(u:UnitArrow):UnitArrow {
    u = u.add(it('should be equal',eq(3), [1,2,3,4,5].count(function(v) return v % 2 != 0)));
    return u;
  }
  
  public function testCountWhile(u:UnitArrow):UnitArrow {
    u = u.add(it('should be equal',eq(2), [1,2,3,4,5].count(function(v) return v < 3)));
    return u;
  }
  
  public function testScanl(u:UnitArrow):UnitArrow {
    var r = [1,2,3,4,5].scanl(1, function(a, b) return a + b);
    u = u.add(it('should be equal',eq([1,2,3,4,5,6]), r));
    return u;
  }
  
  public function testScanr(u:UnitArrow):UnitArrow {
    var r = [1,2,3,4,5].scanr(1, function(a, b) return a + b);
    u = u.add(it('should be equal',eq([1,6,5,4,3,2]), r));
    return u;
  }
  
  public function testScanl1(u:UnitArrow):UnitArrow {
    var r = [1,2,3,4,5].scanl1(function(a, b) return a + b);
    u = u.add(it('should be equal',eq([1,3,4,5,6]), r));
    return u;
  }
  
  public function testScanr1(u:UnitArrow):UnitArrow {
    var r = [1,2,3,4,5].scanr1(function(a, b) return a + b);
    u = u.add(it('should be equal',eq([5,9,8,7,6]), r));
    return u;
  }
  
  public function testAppendAll(u:UnitArrow):UnitArrow {
    u = u.add(it('should be equal',eq([1,2,3]), [1].append([2,3])));
    return u;
  }
  
  public function testIsEmpty(u:UnitArrow):UnitArrow {
    u = u.add(it('should be empty',ok(),[].isEmpty()));
    u = u.add(it('should not be empty',no(),[1].isEmpty()));
    return u;
  }
  
  public function testFind(u:UnitArrow):UnitArrow {
    u = u.add(it('should be equal',eq(None), [1,2,3].find(function(v) return v == 4)));
    u = u.add(it('should be equal',eq(Some(2)), [1,2,3].find(function(v) return v == 2)));
    return u;
  }
  
  public function testForAll(u:UnitArrow):UnitArrow {
    u = u.add(it('should be ok',ok(),[1,2,3].all(function(v) return v < 4)));
    u = u.add(it('should not be ok',no(),[1,2,3].all(function(v) return v < 2)));
    return u;
  }
  
  public function testForAny(u:UnitArrow):UnitArrow {
    u = u.add(it('should not be ok',no(),[1,2,3].any(function(v) return v > 3)));
    u = u.add(it('should be ok',ok(),[1,2,3].any(function(v) return v < 2)));
    return u;
  } 
  
  public function testExists(u:UnitArrow):UnitArrow {
    u = u.add(it('should not be ok',no(),[1,2,3].exists(function(v) return v == 4)));
    u = u.add(it('should be ok',ok(),[1,2,3].exists(function(v) return v == 2)));
    return u;
  }
  
  public function testExistsP(u:UnitArrow):UnitArrow {
    var f = function(v, ref) return v == ref;
    u = u.add(it('should not be ok',no(),[1,2,3].existsP(4, f)));
    u = u.add(it('should not be ok',ok(),[1,2,3].existsP(2, f)));
    return u;
  }
  
  public function testNubBy(u:UnitArrow):UnitArrow {
    u = u.add(it('should be equal',eq([1,2,3]), [1,2,2,3,1].nub()));
    return u;
  }                        
  
  public function testNub(u:UnitArrow):UnitArrow {
    u = u.add(it('should be equal',eq([1,2,3]), [1,2,2,3,1].nubBy(function(a,b) return a == b)));
    return u;
  }
  
  public function testIntersectBy(u:UnitArrow):UnitArrow {
    u = u.add(it('should be equal',eq([2,3]), [1,2,3].intersectBy([2,3,4,5], function(a,b) return a == b)));
    return u;
  }
  
  public function testIntersect(u:UnitArrow):UnitArrow {
    u = u.add(it('should be equal',eq([2,3]), [1,2,3].intersect([2,3,4,5])));  
    return u;
  }
  
  public function testMkString(u:UnitArrow):UnitArrow {
    u = u.add(it('should be equal',eq("A-B-C"), ArrayShow.mkString(["a","b","c"],"-", function(s) return s.toUpperCase())));
    return u;
  }
  
  public function testToMap(u:UnitArrow):UnitArrow {
    var map = [tuple2("a", 1), tuple2("b", 2)].toMap();
    u = u.add(it('should be',is(stx.ds.Map), map));
    u = u.add(it('should be equal',eq(2), map.size()));
    return u;
  }
  
  public function testToList(u:UnitArrow):UnitArrow {
    var list = [1,2,3].toList();
    u = u.add(it('should be',is(stx.ds.List), list));
    u = u.add(it('should be equal',eq(3), list.size()));
    return u;
  }
  
  public function testToSet(u:UnitArrow):UnitArrow {
    var set = [1,2,2,3,1].toSet();
    u = u.add(it('should be',is(stx.ds.Set), set));
    u = u.add(it('should be equal',eq(3), set.size()));
    return u;
  }
  
  public function testGroupBy(u:UnitArrow):UnitArrow {
    var arr = [1,2,3,4,5,6,7,8,9,10];
    var primes = [7, 5, 3, 2];
    var r = arr.groupBy(function(v) {
      for(p in primes)
        if(v % p == 0)
          return p;
      return 1;
    });
    u = u.add(it('should be equal',eq(
      Map.create()
      .set(1, [1])
      .set(2, [2,4,8])
      .set(3, [3,6,9])
      .set(5, [5, 10])
      .set(7, [7]))
      ,
      r
    ));
    return u;
  }
  public function testPad(u:UnitArrow):UnitArrow{
    var arr = [1,2,3,4];
        arr = arr.pad(6);
    return u.add(it('should be 6',eq(6),arr.length));
  }
}