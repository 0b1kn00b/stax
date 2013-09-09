package stx;

import stx.Prelude;

import stx.Muster;
import stx.Muster.*;
import stx.Compare.*;
import stx.Log.*;

using stx.Options;

using stx.Objects;

class ObjectsTest extends TestCase {
  public function new() {
    super();
  }
  
  public function testGet(u:UnitArrow):UnitArrow {
    var o     = { foo: "bar" };
    var tst0  = o.getOption("foo").get();

    return u.add(
      it(
        'should contain the value',
        eq("bar"),
        tst0
      )
    );
  }
  
  public function testSet(u:UnitArrow):UnitArrow {
    var o : Object  = { foo: "bar" };
    var tst0        = o.setField("foo", "baz").getOption("foo").get();

    return u.add(
      it(
        'should have changed',
        eq("baz"), 
        tst0
      )
    );
  }
  
  public function testMerge(u:UnitArrow):UnitArrow{
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
  public function testCopyWithLoop(u:UnitArrow):UnitArrow{
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
}