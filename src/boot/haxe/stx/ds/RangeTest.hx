package stx.ds;

import stx.ds.range.*;

using haxe.unit.TestCases;

import stx.io.Log.*;

using stx.ds.Range;

import haxe.unit.TestCase;

class RangeTest extends TestCase{
  public function testArrayRange(){
    var a = [1,2,3];
    var b : Range<Int> = a;
    var c = [];
    b.each(c.push);
    isEqual(a,c);
  }
  public function testIteratorRange(){
    var a = [1,2,3];
    var b = new IteratorRange(a.iterator());
    var c = [];
    b.each(c.push);
    isEqual(a,c);
    var b = new IterableRange(a);
    var c = [];
    b.each(c.push);
    isEqual(a,c);
  }
  @:note('one shot at the moment.')
  /*public function testAppend(){
    trace('a');
    var a = [1,2,3];
    trace('b');
    var b = [4,5,6];
    trace('c');
    var c = a.append(b);
    trace('d');
    var d = [];
    c.each(d.push);
    c.each(printer());
    trace('e');
    var e : Range<Int> = d;
    e.each(printer());
    isEqual(c,e);
  }*/
}