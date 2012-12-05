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
    
    assertEquals("bar", o.getAnyO("foo").get());
  }
  
  public function testSet() {
    var o = { foo: "bar" };
    
    assertEquals("baz", o.setAnyO("foo", "baz").getAnyO("foo").get());
  }
  
  public function testReplaceAll() {
    var o = { foo: "bar", bar: "foo" };
    
    var replaced = o.replaceAllAny({foo: "foo"}, '');
    
    assertEquals("bar", replaced.getAnyO("foo").get());
    
    assertTrue(replaced.getAnyO("bar").isEmpty());
  }
}