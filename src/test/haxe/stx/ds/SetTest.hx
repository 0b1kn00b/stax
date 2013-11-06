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
package stx.ds;

import Prelude;

import stx.ds.ifs.Foldable;

using stx.UnitTest;
import Stax.*;
import stx.Compare.*;

import stx.ds.Set;

using stx.ds.Foldables;

class SetTest extends TestCase {
  public function testSizeGrowsWhenAddingUniqueElements(u:UnitArrow):UnitArrow {
    var s = set();
    
    for (i in 0...100) {
      u = u.add(isEqual(i, s.size()));
      
      s = s.add(i);
    }    
    u = u.add(isEqual(100, s.size()));
    return u;
  }
  public function testSizeDoesNotGrowWhenAddingDuplicateElements(u:UnitArrow):UnitArrow {
    var s = set().add(0);
    
    for (i in 0...100) s = s.add(0);
    
    u = u.add(isEqual(1, s.size()));
    return u;
  }
  public function testSizeShrinksWhenRemovingElements(u:UnitArrow):UnitArrow {
    var s = defaultSet();
    
    for (i in 0...100) {
      u = u.add(isEqual(100 - i, s.size()));
      
      s = s.remove(i);
    }
    
    u = u.add(isEqual(0, s.size()));
    return u;
  }
  public function testContainsElements(u:UnitArrow):UnitArrow {
    var s = set();
    
    for (i in 0...100) {
      u = u.add(isFalse(s.contains(i)));
      
      s = s.add(i);
      
      u = u.add(isTrue(s.contains(i)));
    }
    return u;
  }
  public function testAddingSameElementDoesNotChangeSet(u:UnitArrow):UnitArrow {
    var s = defaultSet();
    
    for (i in 0...100) {
      var oldM = s;
      
      s = s.add(i);
      
      u = u.add(isEqual(oldM, s));
      u = u.add(isEqual(100, s.size()));
    }
    return u;
  }
  public function testCanIterateThroughElements(u:UnitArrow):UnitArrow {
    var s = defaultSet();
    
    var count = 4950;
    var iterated = 0;
    
    for (k in s) {
      count -= k;
      
      ++iterated;
    }

    u = u.add(isEqual(100, iterated));
    u = u.add(isEqual(0,   count));
    return u;
  }
  
  public function testFilter(u:UnitArrow):UnitArrow {
    var s = defaultSet().filter(function(e) { return e < 50; });
    
    u = u.add(isEqual(50, s.size()));
    return u;
  } 

  public function testEquals(u:UnitArrow):UnitArrow {  
    u = u.add(isTrue(set().equals(set())));
    u = u.add(isTrue(set([1,2,3]).equals(set([1,2,3]))));
    u = u.add(isTrue(set([2,1]).equals(set([1,2]))));
    u = u.add(isFalse(set().equals(set([1]))));
    u = u.add(isFalse(set([2]).equals(set([1]))));
    u = u.add(isFalse(set([1,2]).equals(set([1,3]))));
    return u;
  }

  public function testCompare(u:UnitArrow):UnitArrow {                
    u = u.add(isTrue(set().compare(set()) == 0));
    u = u.add(isTrue(set([1,2,3]).compare(set([1,2,3])) == 0));
    u = u.add(isTrue(set().compare(set([1])) < 0));
    u = u.add(isTrue(set([2]).compare(set([1])) > 0));
    u = u.add(isTrue(set([1,2]).compare(set([1,3])) < 0));
    return u;
  }

  public function testToString(u:UnitArrow):UnitArrow {           
    trace(set());
    u = u.add(isEqual("Set ()", set().toString()));
    u = u.add(isEqual("Set (1, 2, 3)", set([1,2,3]).toString())); 
    return u;
  }     

  public function testMapCode(u:UnitArrow):UnitArrow {       
    u = u.add(isNotEqual(0, set().hashCode()));
    u = u.add(isNotEqual(0, set([1,2]).hashCode())) ;
    return u;
  }
    
  function defaultSet(): Set<Int> {
    var s = set();
    
    for (i in 0...100) s = s.add(i);
    
    return s;
  }
  
  function set<T>(?values : Array<T>): Set<T> {
    var s = Set.create();
    if(null != values)
      s = s.append(values);
    return s;
  }
} 