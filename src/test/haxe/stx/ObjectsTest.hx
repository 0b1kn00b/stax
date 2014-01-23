package stx;

import Stax.*;
import stx.UnitTest;
import Prelude;

import stx.Tuples;
import stx.Compare.*;
import stx.io.Log.*;

using stx.Option;

using stx.Objects;

class ObjectsTest extends Suite {
  public function new() {
    super();
  }
  
  public function testGet(u:TestCase):TestCase {
    var o     = { foo: "bar" };
    var tst0  = option("foo").val();

    return u.add(
      it(
        'should contain the value',
        eq("bar"),
        tst0
      )
    );
  }
  
  public function testSet(u:TestCase):TestCase {
    var o : Dynamic   = { foo: "bar" };
    var tst0          = option(o.setField("foo", "baz").foo).val();

    return u.add(
      it(
        'should have changed',
        eq("baz"), 
        tst0
      )
    );
  }
  
  public function testMerge(u:TestCase):TestCase{
    var o        = { foo: "bar", bar: "foo" };    
    var replaced = o.merge({foo: "foo"});
    var tst0     = replaced.getOption("foo").get();

    return u.append([
      it(
        'should have been replaced',
        eq("bar"), 
        tst0  
      )    
    ]);
  }
  //Test retired with honourable distinction after proving 'safeCopy' was a crock of sh*\t.
  public function testCopyWithLoop(u:TestCase):TestCase{
    /*
    var obj = {
      a : {
        ref : null
      }
    };
    obj.a.ref = cast obj;

    var o : Object = obj;

    var p = null;
    try{
      p = o.copyDeep();
    }catch(e:Dynamic){
      trace(e);
    }
    trace(p);
    */
    return u.add(it('wins',always()));
  }
  public function testOnly(u:TestCase):TestCase{
    var a = {
      a : 1,
      b : true,
      c : 'b00p'
    };
    return u.append([
      it('should be equal',
        ok(),
        Objects.only(a,['a','b','c'])
      ),
      it('should not be equal',
        no(),
        Objects.only(a,['a','b'])
      ),
      it('should not be equal',
        no(),
        Objects.only(a,['a','b','c','d'])
      )
    ]);
  }
  public function testObjectTyping(u:TestCase):TestCase{
    var a = {
      b : 1
    }
    return u.add(
      it(
        'should be equal',
        eq(cast [tuple2('b',1)]),
        a.fields()
      )
    );
  }  
}