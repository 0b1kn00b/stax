package stx;

import stx.Prelude;

import stx.Muster;
import stx.Muster.Test.*;
import stx.Log.*;

using stx.Options;

using stx.Objects;

class ObjectsTest extends TestCase {
  public function new() {
    super();
  }
  
  public function testGet(u:UnitArrow):UnitArrow {
    var o = { foo: "bar" };
    
    var tst0 = test().isEqualTo("bar", o.getAnyO("foo").get());
    return u.add(tst0);
  }
  
  public function testSet(u:UnitArrow):UnitArrow {
    var o : Object = { foo: "bar" };
    
    var tst0 = test().isEqualTo("baz", o.setAny("foo", "baz").getAnyO("foo").get());
    return u.add(tst0);
  }
  
  public function testReplaceAll(u:UnitArrow):UnitArrow{
    var o = { foo: "bar", bar: "foo" };
    
    var replaced = o.replaceAllAny({foo: "foo"}, '');
    
    var tst0 = test().isEqualTo("bar", replaced.getAnyO("foo").get());
    
    var tst1 = test().isTrue(replaced.getAnyO("bar").isEmpty());

    return u.append([tst0,tst1]);
  }
  public function testCopyWithLoop(u:UnitArrow):UnitArrow{
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

    return u;
  }
}