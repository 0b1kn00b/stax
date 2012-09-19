package stx;

import stx.Prelude;

import stx.test.TestCase;
import stx.Objects;                   using stx.Options;

using stx.Objects;

class ObjectsTest extends TestCase {
  public function new() {
    super();
  }
  
  public function testGet() {
    var o = { foo: "bar" };
    
    assertEquals("bar", o.getAny("foo").get());
  }
  
  public function testSet() {
    var o = { foo: "bar" };
    
    assertEquals("baz", o.setAny("foo", "baz").getAny("foo").get());
  }
  
  public function testReplaceAll() {
    var o = { foo: "bar", bar: "foo" };
    
    var replaced = o.replaceAllAny({foo: "foo"}, '');
    
    assertEquals("bar", replaced.getAny("foo").get());
    
    assertTrue(replaced.getAny("bar").isEmpty());
  }
}