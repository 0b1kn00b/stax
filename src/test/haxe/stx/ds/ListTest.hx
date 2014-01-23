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

using stx.UnitTest;
import stx.io.Log.*;

import Prelude;

import stx.Plus;
import stx.Equal;

import stx.ds.ifs.Foldable;

import stx.ds.List;

using stx.ds.Foldables;

using stx.Iterables;
using stx.Tuples;
using stx.Maths;


class ListTest extends Suite {
  public function testSizeGrowsWhenAddingUniqueElements(u:TestCase):TestCase{
    var l = newList();
    
    for (i in 0...100) {
      u = u.add(isEqual(i, l.size()));
      
      l = l.add(i);
    }
    
    u = u.add(isEqual(100, l.size()));
    return u;
  }
  
  public function testSizeGrowsWhenAddingDuplicateElements(u:TestCase):TestCase {
    var l = newList().add(0);
    
    for (i in 0...100) l = l.add(0);
    
    u = u.add(isEqual(101, l.size()));
    return u;
  }
  
  public function testSizeShrinksWhenRemovingElements(u:TestCase):TestCase {
    var l = defaultList();
    
    for (i in 0...100) {
      u = u.add(isEqual(100 - i, l.size()));
      
      l = l.remove(i);
    }
    
    u = u.add(isEqual(0, l.size()));
    return u;
  }
  
  public function testContainsElements(u:TestCase):TestCase {
    var l = newList();
    
    for (i in 0...100) {
      u = u.add(isFalse(l.contains(i)));
      
      l = l.add(i);
      
      u = u.add(isTrue(l.contains(i)));
    }
    return u;
  }
  
  public function testCanIterateThroughElements(u:TestCase):TestCase {
    var l = defaultList();
    
    var count = 4950;
    var iterated = 0;
    
    for (k in l) {
      count -= k;
      
      ++iterated;
    }

    u = u.add(isEqual(100, iterated));
    u = u.add(isEqual(0,   count));

    return u;
  }
  
  public function testFilter(u:TestCase):TestCase {
    var l = defaultList().filter(function(e) { return e < 50; });
    
    u = u.add(isEqual(50, l.size()));
    return u;
  }
  
  public function testSort(u:TestCase):TestCase {
    var ul = newList().append([9, 2, 1, 100]);
    var ol = newList().append([1, 2, 9, 100]);
    
    u = assertListEquals(ol, ul.sort(),u);
    return u;
  }  
  
  public function testSortWith(u:TestCase):TestCase {
     var ul = newList().append([9, 2, 1, 100]);
     var ol = newList().append([1, 9, 2, 100]);
     
     var oddsfirst = function(a, b) {
       if(a == b)
         return 0;
       var aeven = a % 2 == 0;
       var beven = b % 2 == 0;   
       if((aeven && beven) || (!aeven && !beven))
         return a - b;
       else if(aeven)
         return 1;
       else
         return -1;
     };
     u = assertListEquals(ol, ul.withOrderFunction(oddsfirst).sort(),u);
     return u;
  }
  
  public function testReverse(u:TestCase):TestCase {
    var l = newList().append([9, 2, 1, 100]);
    var rl = newList().append([100, 1, 2, 9]);
    
    u = assertListEquals(rl, l.reverse(),u);
    return u;
  }
  
  public function testFoldRight(u:TestCase):TestCase {
    u = u.add(isEqual(4950, defaultList().foldRight(0, function(b, a){
      return a + b;
    })));
    return u;
  }
  
  public function testLast(u:TestCase):TestCase {
    u = u.add(isEqual(99, defaultList().last));
    return u;
  }
  
  public function testLastOption(u:TestCase):TestCase {
    switch (defaultList().lastOption) {
      case Some(v): u = u.add(isEqual(99, v));
      
      default: u = u.add(isTrue(false));
    }
    return u;
  }
  
  public function testHead(u:TestCase):TestCase {
    u = u.add(isEqual(0, defaultList().head));
    return u;
  }
  
  public function testHeadOption(u:TestCase):TestCase {
    switch (defaultList().headOption) {
      case Some(v): u = u.add(isEqual(0, v));
      
      default: u = u.add(isTrue(false));
    }
    return u;
  }
  
  public function testZip(u:TestCase):TestCase {
    var l = defaultList().zip(defaultList().drop(1));
    
    var i1 = 0, i2 = 1;

    for (z in l) {
      u = u.add(isEqual(z, tuple2(i1,i2)));
      
      ++i1; ++i2;
    }
    
    u = u.add(isEqual(99, l.size()));
    return u;
  }    

  public function testEquals(u:TestCase): TestCase {
    u = u.add(isTrue (newList().equals(newList()))); 
    u = u.add(isTrue (newList([1,2,3]).equals(newList([1,2,3]))));
    u = u.add(isFalse(newList([1,2,3]).equals(newList([2,2,3]))));
    u = u.add(isFalse(newList([1,2,3]).equals(newList([1]))));
    
    var list = List.create( 
			Plus.tool(
				function(a : Float, b : Float) return Math.abs(a - b) < 0.25
			)
		).append([1.0, 2.1]);

    u = u.add(isTrue (list.equals(newList([0.9, 2.0]))));
    u = u.add(isFalse(list.equals(newList([0.9, 2.4])))); 
    u = u.add(isFalse(list.equals(newList([0.7, 2.0])))); 
    return u;
  }

  public function testCompare(u:TestCase): TestCase{
    u = u.add(isTrue(newList().compare(newList()) == 0));
    u = u.add(isTrue(newList([1,2,3]).compare(newList([1,2,3])) == 0));

    u = u.add(isTrue(newList([1,2,3]).compare(newList([2,2,3])) < 0));
    u = u.add(isTrue(newList([1,2,3]).compare(newList([1])) > 0));
    
    var list = List.create(Plus.tool(function(a : Float, b : Float) return Math.abs(a-b) < 0.25 ? 0 : (a > b ? 1 : -1))).append([1.0, 2.1]);

    u = u.add(isTrue(list.compare(newList([0.9, 2.0])) == 0));
    u = u.add(isTrue(list.compare(newList([0.9, 2.4])) < 0)); 
    u = u.add(isTrue(list.compare(newList([0.7, 2.0])) > 0));
    return u;
  }

  public function testToString(u:TestCase): TestCase { 
    u = u.add(isEqual("List []", newList().toString())); 
    u = u.add(isEqual("List [a, b]", newList(["a", "b"]).toString()));

    var list = List.create(Plus.tool(function(a : String) return '"' + a +'"')).append(["a", "b"]);

    u = u.add(isEqual('List ["a", "b"]', list.toString()));
    return u;
  }     

  public function testMapCode(u:TestCase): TestCase {
    u = u.add(isNotEqual(0, newList().hashCode()));
    u = u.add(isNotEqual(0, newList([1,2]).hashCode()));
    return u;
  }
  
  public function testIntListMapToString(u:TestCase): TestCase{
    var list = List.create().append([1,2,3]);
    var slist : Foldable<List<String>, String> = list.map(function(i) return i.toString());
    u = u.add(isEqual(["1", "2", "3"], slist.toArray())); 
    return u;
  }
     

  function newList<T>(?values : Array<T>) : List<T> {
    var list = List.create();
    if(null != values)
      return list.append(values);  
    else
      return list;
  }
  
  function assertListEquals(l1: List<Int>, l2: List<Int>, ?pos : haxe.PosInfos, u: TestCase): TestCase{
    u = u.add(isTrue(l1.equals(l2), pos)); 
    u = u.add(isTrue(Equal.getEqualFor(l1)(l1, l2), pos)); 
    return u;
  }
  
  function defaultList(): List<Int> {
    var l = newList();
    
    for (i in 0...100) l = l.add(i);
    
    return l;
  }
}