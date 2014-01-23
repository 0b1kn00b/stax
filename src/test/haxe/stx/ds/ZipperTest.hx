package stx.ds;

import Prelude; 
using stx.UnitTest;
import stx.Compare.*;
import stx.io.Log.*;

using stx.ds.Zipper;

class ZipperTest extends Suite{
	public function testSomething(u:TestCase){
    var a = {
      b : {},
       c : {
        d : 1,
        e : [
          "a","b"
        ],
        f : Some({
          g : 2,
          h : false
        })
      } 
    };
    var zp = Zipper.pure(a).dn(function(x) return x.c).dn(function(x) return x.d);
    var f = zp.up();
    var d = zp.up().up();
    
    var x = zp.value();
    //$type(x);
    //trace(x);
    var y = f.value();
    //$type(y);
    //trace(y);
    var z = d.value();
    //$type(z);
    //trace(zp.value()); 
    switch (zp) {
      //case Zipped(_,_,p) : trace(p.value());
      case Zipped(_,_,Zipped(_,_,p)) : //trace(p.value());
      //default : 
    }
    

    return u.add(it('should be the same value',eq(a.c.d),x))
            .add(it('should be the same value',eq(a.c),y))
            .add(it('should be the same value',eq(a),z));
	}
}