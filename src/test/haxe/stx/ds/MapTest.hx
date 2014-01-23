package stx.ds;

import stx.Tuples;
import Prelude;

import stx.ds.ifs.Foldable;
import Stax.*;
import stx.Compare.*;
import stx.ds.Map;

using stx.UnitTest;
using stx.ds.Foldables;
using stx.ds.Map;
using stx.Tuples;
using stx.Option;

class MapTest extends Suite {
  /*public function testAdd(u:TestCase):TestCase{
    var m   = Map.create();
    var m2  = m.set( tuple2('a',1) );
    trace(m2);
  }*/
  public function testSizeGrowsWhenAddingUniqueKeys(u:TestCase):TestCase {
    var m = map();
    
    for (i in 0...100) {
      u = u.add(isEqual(i, m.size()));
      
      m = m.set(i, "foo");
    }
    
    u = u.add(isEqual(100, m.size()));
    return u;
  }
  
  public function testSizeGrowsWhenAddingDuplicateKeys(u:TestCase):TestCase {
    var m = map().set(0, "foo");
    
    for (i in 0...100) m = m.set(0, "foo");
    
    u = u.add(isEqual(1, m.size()));
    return u;
  }
  
  public function testCanRetrieveValuesForKeys(u:TestCase):TestCase {
    var m = defaultMap();
    
    for (i in 0...100) {
      u = u.add(isEqual("foo", m.get(i).valOrUse(function() return "bar")));
    }
    return u;
  }

  public function testSizeShrinksWhenRemovingKeys(u:TestCase):TestCase {
    var m = defaultMap();
    
    for (i in 0...100) {
      u = u.add(isEqual(100 - i, m.size()));
      
      m = m.removeByKey(i);
    }
    
    u = u.add(isEqual(0, m.size()));
    return u;
  }
  
  public function testLoadNeverExceedsMax(u:TestCase):TestCase {
    var m = map();
    
    for (i in 0...100) {
      m = m.set(i, "foo");
      
      u.add(isTrue(m.load() <= Map.MaxLoad));
    }
    return u;
  }
  
  public function testContainsKeys(u:TestCase):TestCase {
    var m = map();
    
    for (i in 0...100) {
      u.add(isFalse(m.containsKey(i)));
      
      m = m.set(i, "foo");
      
      u.add(isTrue(m.containsKey(i)));
    }
    return u;
  }
  
  public function devtestAddingSameKeysAndSameValueDoesNotChangeMap(u:TestCase):TestCase {
    var m = defaultMap();
    
    for (i in 0...100) {
      var oldM = m;
      
      m = m.set(i, "foo");
      
      u = u.add(isEqual(oldM, m));
      u = u.add(isEqual(100, m.size()));
    }
    return u;
  }
  
  public function testAddingSameKeyButDifferentValueUpdatesMap(u:TestCase):TestCase {
    var m = defaultMap();
    
    for (i in 0...100) {
      m = m.set(i, "bar");

      u = u.add(isEqual("bar", m.get(i).val()));
      u = u.add(isEqual(100, m.size()));
    }
    return u;
  }
  
  public function testCanIterateThroughKeys(u:TestCase):TestCase {
    var m = defaultMap();
    
    var count = 4950;
    var iterated = 0;
    
    for (k in m.keys()) {
      count -= k;
      
      ++iterated;
    }

    u = u.add(isEqual(100, iterated));
    u = u.add(isEqual(0,   count));
    return u;
  }
  
  public function testCanIterateThroughValues(u:TestCase):TestCase {
    var m = defaultMap();
    
    for (v in m.values()) {
      u = u.add(isEqual("foo", v));
    }
    return u;
  }
  
  public function testFilter(u:TestCase):TestCase {
    var m = defaultMap().filter(function(t) { return t.fst() < 50; });
    
    u = u.add(isEqual(50, m.size()));
    return u;
  }  

  public function testEquals(u:TestCase):TestCase { 
    u.add(isTrue (map().equals(map())));
    u.add(isTrue (map([tuple2(1, "a")]).equals(map([tuple2(1, "a")]))));
    u.add(isFalse(map([tuple2(1, "a")]).equals(map([tuple2(2, "a")]))));
    u.add(isFalse(map([tuple2(1, "a")]).equals(map([tuple2(1, "b")])))); 
    u.add(isFalse(map([tuple2(1, "a")]).equals(map([tuple2(1, "a"), tuple2(2, "a")]))));
    return u;
  }

  public function testCompare(u:TestCase):TestCase {  
    u.add(isTrue(map().compare(map()) == 0));
    u.add(isTrue(map([tuple2(1, "a")]).compare(map([tuple2(1, "a")])) == 0)); 
    u.add(isTrue(map([tuple2(1, "a")]).compare(map([tuple2(2, "a")])) < 0));
    u.add(isTrue(map([tuple2(1, "a")]).compare(map([tuple2(1, "b")])) < 0));
    u.add(isTrue(map([tuple2(1, "a")]).compare(map([tuple2(1, "a"), tuple2(2, "a")])) < 0));
    u.add(isTrue(map([tuple2(2, "a")]).compare(map([tuple2(1, "b")])) > 0));
    return u;
  }

  public function testToString(u:TestCase):TestCase {    
    u = u.add(isEqual("Map ()", map().toString()));
    u = u.add(isEqual("Map (1 -> a, 2 -> a)", map([tuple2(1, "a"), tuple2(2, "a")]).toString()));
    return u;
  }     

  public function testMapCode(u:TestCase):TestCase {     
    u = u.add(isNotEqual(0, map().hashCode()));
    u = u.add(isNotEqual(0, map([tuple2(1, "a"), tuple2(2, "a")]).hashCode()));
    return u;
  }
    
  function defaultMap():Map<Int, String> {
    var m = map();
    
    for (i in 0...100) m = m.set(i, "foo");
    
    return m;
  }
  
  function map(?defaults : Array<Tuple2<Int, String>>): Map<Int, String> {
    var m = Map.create();      
  if(null != defaults)
    m = m.append(defaults);
    return m;
  }
}