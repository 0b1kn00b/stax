package stx.ds;

import stx.Muster;
import stx.Muster.*;
import stx.Log.*;

using stx.ds.Link;

class LinkTest extends TestCase{
  public function testLink(u:UnitArrow):UnitArrow{
    var a = 'hello';
    var b = 'world';
    var c = 1;
    var d = false;
    var l = new Link(a,null).then(b).then(c).then(d);
    $type(l); 
    var m = l.back();
    $type(m);
    var n = m.back();
    $type(n);

    var o = new FunctionLink(function(x:Int):Float{return x * 0.2;}).map(
      function(x){ return Std.string(x); }
    );
    $type(o);
    var p = o.back();
    $type(p);
    
    return u;
  }
}

    