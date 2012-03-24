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
package stx.data.collections;

import stx.Tuples;
import Prelude;

import stx.functional.Foldable;
import stx.test.TestCase;
import stx.data.collections.Map;

using stx.functional.FoldableExtensions;

using stx.Options;

class MapTestCase extends TestCase {
  public function testSizeGrowsWhenAddingUniqueKeys(): Void {
    var m = map();
    
    for (i in 0...100) {
      assertEquals(i, m.size());
      
      m = m.set(i, "foo");
    }
    
    assertEquals(100, m.size());
  }
  
  public function testSizeGrowsWhenAddingDuplicateKeys(): Void {
    var m = map().set(0, "foo");
    
    for (i in 0...100) m = m.set(0, "foo");
    
    assertEquals(1, m.size());
  }
  
  public function testCanRetrieveValuesForKeys(): Void {
    var m = defaultMap();
    
    for (i in 0...100) {
      assertEquals("foo", m.get(i).getOrElse(function() return "bar"));
    }
  }
  
  public function testSizeShrinksWhenRemovingKeys(): Void {
    var m = defaultMap();
    
    for (i in 0...100) {
      assertEquals(100 - i, m.size());
      
      m = m.removeByKey(i);
    }
    
    assertEquals(0, m.size());
  }
  
  public function testLoadNeverExceedsMax(): Void {
    var m = map();
    
    for (i in 0...100) {
      m = m.set(i, "foo");
      
      assertTrue(m.load() <= Map.MaxLoad);
    }
  }
  
  public function testContainsKeys(): Void {
    var m = map();
    
    for (i in 0...100) {
      assertFalse(m.containsKey(i));
      
      m = m.set(i, "foo");
      
      assertTrue(m.containsKey(i));
    }
  }
  
  public function testAddingSameKeysAndSameValueDoesNotChangeMap(): Void {
    var m = defaultMap();
    
    for (i in 0...100) {
      var oldM = m;
      
      m = m.set(i, "foo");
      
      assertEquals(oldM, m);
      assertEquals(100, m.size());
    }
  }
  
  public function testAddingSameKeyButDifferentValueUpdatesMap(): Void {
    var m = defaultMap();
    
    for (i in 0...100) {
      m = m.set(i, "bar");

      assertEquals("bar", m.get(i).get());
      assertEquals(100, m.size());
    }
  }
  
  public function testCanIterateThroughKeys(): Void {
    var m = defaultMap();
    
    var count = 4950;
    var iterated = 0;
    
    for (k in m.keys()) {
      count -= k;
      
      ++iterated;
    }

    assertEquals(100, iterated);
    assertEquals(0,   count);
  }
  
  public function testCanIterateThroughValues(): Void {
    var m = defaultMap();
    
    for (v in m.values()) {
      assertEquals("foo", v);
    }
  }
  
  public function testFilter(): Void {
    var m = defaultMap().filter(function(t) { return t._1 < 50; });
    
    assertEquals(50, m.size());
  }  

  public function testEquals() { 
  assertTrue (map().equals(map()));
  assertTrue (map([Tuples.t2(1, "a")]).equals(map([Tuples.t2(1, "a")])));
  assertFalse(map([Tuples.t2(1, "a")]).equals(map([Tuples.t2(2, "a")])));
  assertFalse(map([Tuples.t2(1, "a")]).equals(map([Tuples.t2(1, "b")])));   
  assertFalse(map([Tuples.t2(1, "a")]).equals(map([Tuples.t2(1, "a"), Tuples.t2(2, "a")])));
  }

  public function testCompare() {  
  assertTrue(map().compare(map()) == 0);
  assertTrue(map([Tuples.t2(1, "a")]).compare(map([Tuples.t2(1, "a")])) == 0);   
  assertTrue(map([Tuples.t2(1, "a")]).compare(map([Tuples.t2(2, "a")])) < 0);
  assertTrue(map([Tuples.t2(1, "a")]).compare(map([Tuples.t2(1, "b")])) < 0);   
  assertTrue(map([Tuples.t2(1, "a")]).compare(map([Tuples.t2(1, "a"), Tuples.t2(2, "a")])) < 0);   
  assertTrue(map([Tuples.t2(2, "a")]).compare(map([Tuples.t2(1, "b")])) > 0); 
  }

  public function testToString() {    
  assertEquals("Map ()", map().toString());
  assertEquals("Map (1 -> a, 2 -> a)", map([Tuples.t2(1, "a"), Tuples.t2(2, "a")]).toString());
  }     

  public function testHashCode() {     
  assertNotEquals(0, map().hashCode());
  assertNotEquals(0, map([Tuples.t2(1, "a"), Tuples.t2(2, "a")]).hashCode());              
  }
    
  function defaultMap(): Map<Int, String> {
    var m = map();
    
    for (i in 0...100) m = m.set(i, "foo");
    
    return m;
  }
  
  function map(?defaults : Array<Tuple2<Int, String>>): Map<Int, String> {
    var m = Map.create();      
  if(null != defaults)
    m = m.addAll(defaults);
    return m;
  }
}