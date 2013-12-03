import stx.test.Suite;
import stx.test.Assert;

class StringsTest extends Suite{
	  public function testChunk() {
    var result = 'foobarblah'.chunk(3);
    
    var iterator = result.iterator();
    
    assertEquals('foo', iterator.next());
    assertEquals('bar', iterator.next());
    assertEquals('bla', iterator.next());
    assertEquals('h',   iterator.next());
  }
  
  public function testChars() {
    var result = 'foob'.chars();
    
    var iterator = result.iterator();
    
    assertEquals('f', iterator.next());
    assertEquals('o', iterator.next());
    assertEquals('o', iterator.next());
    assertEquals('b', iterator.next());
    
    assertFalse(iterator.hasNext());
  }
  
  public function testString() {
    assertEquals('foobar', 'foobar'.chars().string());
  }
}